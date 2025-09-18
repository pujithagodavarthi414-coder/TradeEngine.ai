using System;

namespace AuthenticationServices.PermissionsMatrix
{
    internal class Program
    {
        [STAThread]
        static void Main()
        {
            GeneratePermissionMatrixScript generatePermissionMatrixScript = new GeneratePermissionMatrixScript();
            generatePermissionMatrixScript.PermissionMatrixScript();
            GenerateFeatureProcedureScript generateFeatureProcedureScript = new GenerateFeatureProcedureScript();
            generateFeatureProcedureScript.FeatureProcedureScripts();
        }
    }
}
