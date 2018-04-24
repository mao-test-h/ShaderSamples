using UnityEngine;

namespace ShaderSamples
{
    public class RenderImage : MonoBehaviour
    {
        [SerializeField] Material _mat;
        void OnRenderImage(RenderTexture src, RenderTexture dest)
        {
            Graphics.Blit(null, dest, this._mat);
        }
    }
}