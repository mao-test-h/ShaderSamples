using System.IO;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEditor.ProjectWindowCallback;

namespace ScriptTemplatesGenerator
{
    /// <summary>
    /// スクリプトテンプレート生成用拡張
    /// </summary>
    public class ScriptTemplatesGenerator : EndNameEditAction
    {
        // --------------------------------------------
        #region // Constants

        /// <summary>
        /// テンプレートパス
        /// </summary>
        const string TemplatesPath = "ScriptTemplatesGenerator/Templates/";

        /// <summary>
        /// 共通メニューパス
        /// </summary>
        const string CommonMenuRoot = "Assets/Create/";

        #endregion // Constants

        // ==============================================
        #region // MenuItem

        /// <summary>
        /// C# Script生成処理
        /// </summary>
        [MenuItem(ScriptTemplatesGenerator.CommonMenuRoot + "C# Script(Original)", false, 64)]
        public static void CreateNewBehaviourScript()
        {
            var resFile = Path.Combine(Application.dataPath, ScriptTemplatesGenerator.TemplatesPath + "/Script-NewBehaviourScript.cs.txt");
            Texture2D icon = EditorGUIUtility.IconContent("cs Script icon").image as Texture2D;
            CreateFile(resFile, icon, "NewCSharpScript.cs");
        }

        /// <summary>
        /// サンプルShader生成処理
        /// </summary>
        [MenuItem(ScriptTemplatesGenerator.CommonMenuRoot + "Sample Shader", false, 65)]
        public static void CreateNewSampleShader()
        {
            var resFile = Path.Combine(Application.dataPath, ScriptTemplatesGenerator.TemplatesPath + "/Shader-NewSampleShader.shader.txt");
            Texture2D icon = EditorGUIUtility.IconContent("Shader Icon").image as Texture2D;
            CreateFile(resFile, icon, "NewSampleShader.shader");
        }

        /// <summary>
        /// サンプルShader生成処理
        /// </summary>
        [MenuItem(ScriptTemplatesGenerator.CommonMenuRoot + "New cginc", false, 66)]
        public static void CreateNewCgIncFile()
        {
            var resFile = Path.Combine(Application.dataPath, ScriptTemplatesGenerator.TemplatesPath + "/Shader-NewCginc.cginc.txt");
            Texture2D icon = EditorGUIUtility.IconContent("Shader Icon").image as Texture2D;
            CreateFile(resFile, icon, "Shader-NewCginc.cginc");
        }

        #endregion // MenuItem

        // ==============================================
        #region // Override

        /// <summary>
        /// 生成処理
        /// </summary>
        /// <param name="instanceId">インスタンスID</param>
        /// <param name="pathName">パス名</param>
        /// <param name="resourceFile">ファイル名</param>
        public override void Action(int instanceId, string pathName, string resourceFile)
        {
            var text = File.ReadAllText(resourceFile);
            var className = Path.GetFileNameWithoutExtension(pathName);

            // スペースを削除
            className = className.Replace(" ", "");
            // ファイル名から拡張子を抜いた物をクラス名に設定
            text = text.Replace("#NAME#", className);

            // UTF8(BOM付き)
            var encoding = new UTF8Encoding(true, false);
            File.WriteAllText(pathName, text, encoding);
            AssetDatabase.ImportAsset(pathName);

            UnityEngine.Object asset = null;
            switch (Path.GetExtension(pathName))
            {
                case ".cs":
                    asset = AssetDatabase.LoadAssetAtPath<MonoScript>(pathName);
                    break;
                case ".shader":
                    asset = AssetDatabase.LoadAssetAtPath<Shader>(pathName);
                    break;
                default:
                    return;
            }
            ProjectWindowUtil.ShowCreatedAsset(asset);
        }

        #endregion // Override

        // ==============================================
        #region // Private Methods

        /// <summary>
        /// ファイル生成処理
        /// </summary>
        /// <param name="resFile">リソース情報</param>
        /// <param name="iconTexture">アイコンのTexture</param>
        /// <param name="createFileName">生成するファイル名(拡張子も含めること)</param>
        static void CreateFile(string resFile, Texture2D iconTexture, string createFileName)
        {
            var endNameEditAction = ScriptableObject.CreateInstance<ScriptTemplatesGenerator>();
            ProjectWindowUtil.StartNameEditingIfProjectWindowExists(0, endNameEditAction, createFileName, iconTexture, resFile);
        }

        #endregion // Private Methods
    }
}
