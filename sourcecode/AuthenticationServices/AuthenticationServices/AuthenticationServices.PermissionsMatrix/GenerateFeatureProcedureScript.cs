using System;
using System.Configuration;
using System.IO;

namespace AuthenticationServices.PermissionsMatrix
{
    public class GenerateFeatureProcedureScript
    {
        public void FeatureProcedureScripts()
        {
            try
            {
                var lastLookup = 0;
                var accessAll = false;
                var outputFilePath = @"..\..\..\USP_ExecuteFeatureProcedureScript.sql";
                var outputFilePathCopyTo = @"..\..\..\..\AuthenticationServices.Database\dbo\Stored Procedures\Common\USP_ExecuteFeatureProcedureScript.sql";

                var insertProcedureString = "INSERT INTO [ProcedureName] (Id,ActionPath,IsActive,LookUpKey,AccessAll,CreatedDateTime,CreatedByUserId) VALUES(NEWID(), N'{0}',1, N'{1}', {2}, GETUTCDATE(), @DefaultUserId)";
                var insertFeatureString = "INSERT INTO [dbo].[FeatureProcedureMapping] (Id,FeatureId,ProcedureName,CreatedDateTime,CreatedByUserId) VALUES(NEWID(),{0}, {1},GETUTCDATE(),@DefaultUserId)";
                var featureCondition = "END\n IF (SELECT count(1) from [Feature] where [Id] = '{0}') > 0\nBEGIN";
                var selectCommandForFeature = "(SELECT [Id] FROM [dbo].[Feature] WHERE [Id] = '{0}')";
                var selectCommandForProcedureAction = "(SELECT [ActionPath] FROM [dbo].[ProcedureName] WHERE [LookUpKey] = '{0}')";
                string range = ConfigurationManager.AppSettings["FeatureProcedureRange"];

                var result = SheetData.GetSheetData(range);
                Console.WriteLine("Generating script....");
                var feature = result[0].ToString();
                File.WriteAllText(outputFilePath, string.Empty);
                File.AppendAllText(outputFilePath, "CREATE PROCEDURE [dbo].[USP_ExecuteFeatureProcedureScript] AS BEGIN\nTRUNCATE TABLE [dbo].[FeatureProcedureMapping] \n TRUNCATE TABLE [dbo].[ProcedureName] END \n DECLARE @DefaultUserId UNIQUEIDENTIFIER = (SELECT Id FROM [dbo].[User] WHERE [UserName] = N'Snovasys.Support@Support')");
                File.AppendAllText(outputFilePath, $"\nIF (select count(1) from Feature where Id = '{feature}') > 0\nBEGIN" + Environment.NewLine);

                for (var i = 1; i < result.Count; i++)
                {
                    var line = result[i].ToString();
                    if (!line.Contains("USP_"))
                    {
                        if (line.Equals("AccessToAll"))
                        {
                            accessAll = true;
                            File.AppendAllText(outputFilePath, "END" + Environment.NewLine);
                        }
                        else
                        {
                            accessAll = false;
                            feature = line;
                            File.AppendAllText(outputFilePath, string.Format(featureCondition, feature) + Environment.NewLine);
                        }
                    }
                    else if (!accessAll)
                    {
                        lastLookup++;
                        File.AppendAllText(outputFilePath, string.Format(insertProcedureString, line, lastLookup.ToString(), 0) + Environment.NewLine);
                        File.AppendAllText(outputFilePath, string.Format(insertFeatureString, string.Format(selectCommandForFeature, feature), string.Format(selectCommandForProcedureAction, lastLookup.ToString())) + Environment.NewLine);
                    }
                    else
                    {
                        File.AppendAllText(outputFilePath, string.Format(insertProcedureString, line, lastLookup.ToString(), 1) + Environment.NewLine);
                    }
                }

                File.Copy(outputFilePath, outputFilePathCopyTo, true);
                Console.WriteLine("Script Generated and copied to clipboard");
                Console.Write("Window will be closed in : ");
            }
            catch (Exception exception)
            {
                var value = exception;
            }
        }
    }
}
