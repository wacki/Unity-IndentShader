using UnityEngine;
using System.Collections;

namespace Wacki.IndentSurface
{

    public class IndentDraw : MonoBehaviour
    {
        public Texture2D texture;      
        public Texture2D stampTexture;  
        public RenderTexture tempTestRenderTexture;
        public int rtWidth = 512;
        public int rtHeight = 512;

        private RenderTexture targetTexture;
        private RenderTexture auxTexture;

        public Material mat;

        // mouse debug draw
        private Vector3 _prevMousePosition;
        private bool _mouseDrag = false;

        void Awake()
        {
            targetTexture = new RenderTexture(rtWidth, rtHeight, 32);

            // temporarily use a given render texture to be able to see how it looks
            targetTexture = tempTestRenderTexture;
            auxTexture = new RenderTexture(rtWidth, rtHeight, 32);

            GetComponent<Renderer>().material.SetTexture("_Indentmap", targetTexture);
            Graphics.Blit(texture, targetTexture);  
        }
        
        // add an indentation at a raycast hit position
        public void IndentAt(RaycastHit hit)
        {
            if (hit.collider.gameObject != this.gameObject)
                return;
            
            float x = hit.textureCoord.x;
            float y = hit.textureCoord.y;

            DrawAt(x * targetTexture.width, y * targetTexture.height, 1.0f);
        }

        void Update()
        {
            if (Camera.main == null)
                return;

            bool draw = false;
            float drawThreshold = 0.01f;

            RaycastHit hit;
            if (Physics.Raycast(Camera.main.ScreenPointToRay(Input.mousePosition), out hit))
            {
                if (hit.collider.gameObject != gameObject)
                    return;
            }

            // force a draw on mouse down
            draw = Input.GetMouseButtonDown(0);
            // set draggin state
            _mouseDrag = Input.GetMouseButton(0);
            

            if (_mouseDrag && (draw || Vector3.Distance(hit.point, _prevMousePosition) > drawThreshold))
            {
                _prevMousePosition = hit.point;
                IndentAt(hit);
            }
        }

        /// <summary>
        /// todo:   it would probably be a bit more straight forward if we didn't use Graphics.DrawTexture
        ///         and instead handle everything ourselves. This way we could directly provide multiple 
        ///         texture coordinates to each vertex.
        /// </summary>
        /// <param name="x"></param>
        /// <param name="y"></param>
        /// <param name="alpha"></param>
        void DrawAt(float x, float y, float alpha)
        {
            Graphics.Blit(targetTexture, auxTexture);

            // activate our render texture
            RenderTexture.active = targetTexture; 

            GL.PushMatrix();
            GL.LoadPixelMatrix(0, targetTexture.width, targetTexture.height, 0);

            x = Mathf.Round(x);
            y = Mathf.Round(y);

            // setup rect for our indent texture stamp to draw into
            Rect screenRect = new Rect();
            // put the center of the stamp at the actual draw position
            screenRect.x = x - stampTexture.width * 0.5f;
            screenRect.y = (targetTexture.height - y) - stampTexture.height * 0.5f;
            screenRect.width = stampTexture.width;
            screenRect.height = stampTexture.height;

            var tempVec = new Vector4();

            tempVec.x = screenRect.x / ((float)targetTexture.width);
            tempVec.y = 1 - (screenRect.y / (float)targetTexture.height);
            tempVec.z = screenRect.width / targetTexture.width;
            tempVec.w = screenRect.height / targetTexture.height;
            tempVec.y -= tempVec.w;

            mat.SetTexture("_MainTex", stampTexture);
            mat.SetVector("_SourceTexCoords", tempVec);
            mat.SetTexture("_SurfaceTex", auxTexture);

            // Draw the texture
            Graphics.DrawTexture(screenRect, stampTexture, mat);

            GL.PopMatrix();
            RenderTexture.active = null; 


        }
    }

}