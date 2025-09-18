using System;

namespace Btrak.PermissionsMatrix
{
    internal class Program
    {
        [STAThread]
        static void Main()
        {
            GeneratePermissionMatrixScript generatePermissionMatrixScript = new GeneratePermissionMatrixScript();
            generatePermissionMatrixScript.PermissionMatrixScript();
            GenerateFeatureProcedureScrpt generateFeatureProcedureScript = new GenerateFeatureProcedureScrpt();
            generateFeatureProcedureScript.FeatureProcedureScrpts();
            GenerateEntityFeatureScrpt generateEntityFeatureScrpt = new GenerateEntityFeatureScrpt();
            generateEntityFeatureScrpt.EntityFeatureProcedureScrpts();
           
        }
    }
}
