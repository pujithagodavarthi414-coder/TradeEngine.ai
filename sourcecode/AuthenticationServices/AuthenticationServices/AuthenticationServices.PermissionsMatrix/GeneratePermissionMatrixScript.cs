using System;
using System.Configuration;
using System.IO;

namespace AuthenticationServices.PermissionsMatrix
{
    public class GeneratePermissionMatrixScript
    {
        public void PermissionMatrixScript()
        {
            try 
            {
                var lastLookup = 0;
                var accessAll = false;
                var outputFilePath = @"..\..\..\USP_ExecutePermissionsMatrix.sql";
                var outputFilePathCopyTo = @"..\..\..\..\AuthenticationServices.Database\dbo\Stored Procedures\Common\USP_ExecutePermissionsMatrix.sql";

                var insertRootActionString = "INSERT INTO [ControllerApiName] (Id,ActionPath,IsActive,LookUpKey,AccessAll,CreatedDateTime,CreatedByUserId) VALUES(NEWID(), N'{0}',1, N'{1}', {2}, GETUTCDATE(), @DefaultUserId)";
                var insertActionFeatureString = "INSERT [dbo].[ControllerApiFeature] (Id,FeatureId,ControllerApiNameId,CreatedDateTime,CreatedByUserId) VALUES(NEWID(),{0}, {1},GETUTCDATE(),@DefaultUserId)";
                var featureCondition = "END\n IF (SELECT count(1) from [Feature] where [Id] = '{0}') > 0\nBEGIN";
                var selectCommandForFeature = "(SELECT [Id] FROM [dbo].[Feature] WHERE [Id] = '{0}')";
                var selectCommandForRootAction = "(SELECT [Id] FROM [dbo].[ControllerApiName] WHERE [LookUpKey] = '{0}')";

                string range = ConfigurationManager.AppSettings["PermissionMatrixRange"];
                var result = SheetData.GetSheetData(range);
                Console.WriteLine("Generating script....");

                if (result == null)
                {
                    result = SheetData.GetSheetData(range);
                    Console.WriteLine("Generating script second time....");
                }

                if (result == null)
                {
                    result = SheetData.GetSheetData(range);
                    Console.WriteLine("Generating script third time....");
                }

                if (result == null)
                {
                    result = SheetData.GetSheetData(range);
                    Console.WriteLine("Generating script fourth time....");
                }

                if (result == null)
                {
                    result = SheetData.GetSheetData(range);
                    Console.WriteLine("Generating script fifth time....");
                }

                var feature = result[0].ToString();
                File.WriteAllText(outputFilePath, string.Empty);
                File.AppendAllText(outputFilePath, "CREATE PROCEDURE [dbo].[USP_ExecutePermissionsMatrix] AS BEGIN\nTRUNCATE TABLE[dbo].[ControllerApiFeature]\nDELETE ControllerApiName END \n DECLARE @DefaultUserId UNIQUEIDENTIFIER = (SELECT Id FROM [dbo].[User] WHERE [UserName] = N'Snovasys.Support@Support')");
                File.AppendAllText(outputFilePath, $"\nIF (select count(1) from Feature where Id = '{feature}') > 0\nBEGIN" + Environment.NewLine);
                
                for (var i = 1; i < result.Count; i++)
                {
                    var line = result[i].ToString();
                    if (!line.Contains('/'))
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
                        File.AppendAllText(outputFilePath, string.Format(insertRootActionString, line, lastLookup.ToString(), 0) + Environment.NewLine);
                        File.AppendAllText(outputFilePath, string.Format(insertActionFeatureString, string.Format(selectCommandForFeature, feature), string.Format(selectCommandForRootAction, lastLookup.ToString())) + Environment.NewLine);
                    }
                    else
                    {
                        lastLookup++;
                        File.AppendAllText(outputFilePath, string.Format(insertRootActionString, line, lastLookup.ToString(), 1) + Environment.NewLine);
                    }
                }

                var scriptText = File.ReadAllText(outputFilePath);

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
