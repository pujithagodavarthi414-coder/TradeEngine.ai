using Btrak.Dapper.Dal.Partial;
using Btrak.Models;
using Btrak.Models.CustomApplication;
using Btrak.Models.GenericForm;
using Btrak.Services.CustomApplication;
using BTrak.Api;
using BTrak.Common;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading;
using Unity;

namespace BTrak.CustomApplicationImport.Service
{
    public class Program
    {
        public static void Main()
        {
            while (true)
            {
                var directoryPath = ConfigurationManager.AppSettings["CustomAppImportFilesPath"].ToString();

                Console.WriteLine("Getting files from the path " + directoryPath);

                LoggedInContext loggedInUser = new LoggedInContext()
                {
                    LoggedInUserId = new Guid(ConfigurationManager.AppSettings["CustomAppImportsUserId"].ToString()),
                    CompanyGuid = new Guid(ConfigurationManager.AppSettings["CustomAppCompanyId"].ToString())
                };

                var files = Directory.GetFiles(directoryPath).ToList();

                files = files.ToList().Where(p => Path.GetExtension(p) == ".xlsx").ToList();

                Console.WriteLine("Found " + files.Count.ToString() + " new files");

                var unityContainer = UnityConfig.SetUpUnityContainer();

                foreach (var file in files)
                {
                    LoggingManager.Info("Fetching data from the file " + Path.GetFileName(file));

                    Console.WriteLine("Fetching data from the file " + Path.GetFileName(file));

                    Guid? customApplicationId = null;

                    var validationMessages = new List<ValidationMessage>();

                    SpreadsheetDocument spreadSheetDocument = SpreadsheetDocument.Open(file, false);
                    WorkbookPart workbookPart = spreadSheetDocument.WorkbookPart;
                    List<Sheet> sheets = spreadSheetDocument.WorkbookPart.Workbook.GetFirstChild<Sheets>().Elements<Sheet>().ToList();

                    LoggingManager.Info("Extracting sheets from the file " + Path.GetFileName(file));

                    Console.WriteLine("Extracting sheets from the file " + Path.GetFileName(file));

                    var customApplicationRepo = unityContainer.Resolve<CustomApplicationRepository>();

                    var customApplicationService = unityContainer.Resolve<CustomApplicationService>();

                    LoggingManager.Info("Getting mappings which are available for user");

                    Console.WriteLine("Getting mappings which are available for user");

                    var mappingsList = customApplicationRepo.GetCustomFieldMapping(new CustomFieldMappingInputModel(), loggedInUser, validationMessages);

                    if(validationMessages.Count > 0)
                    {
                        Console.WriteLine("Got " + validationMessages.First().ValidationMessaage + " while getting mappings");
                    }

                    var fileName = Path.GetFileName(file);

                    CustomFieldMappingApiOutputModel matchedMapping = null;

                    foreach (var mapping in mappingsList)
                    {
                        if (Regex.Match(fileName, mapping.MappingName).Success)
                        {
                            matchedMapping = mapping;
                            customApplicationId = mapping.CustomApplicationId;
                            Console.WriteLine("Mapping Found for " + Path.GetFileName(file));
                            break;
                        }
                    }

                    if (customApplicationId != null)
                    {
                        ValidatedSheetsImportModel validatedSheets = new ValidatedSheetsImportModel()
                        {
                            SelectedMappingId = matchedMapping.MappingId,
                            CustomApplicationId = customApplicationId,
                            MappingName = matchedMapping.MappingName,
                            TimeStamp = matchedMapping.TimeStamp,
                            FormImports = new List<ExcelSheetRawModel>()
                        };

                        LoggingManager.Info("Extracting data from the file");

                        Console.WriteLine("Extracting data from the file");

                        var verifiedExcelData = customApplicationService.ImportCustomApplicationFromExcel(customApplicationId.Value,null, spreadSheetDocument, fileName, loggedInUser, validationMessages);

                        var mapping = JsonConvert.DeserializeObject<List<sheets>>(matchedMapping.MappingJson);

                        foreach (var sheet in verifiedExcelData.Sheets)
                        {
                            foreach (var form in mapping)
                            {
                                if (form.sheetName.Trim().ToLower() == sheet.SheetName.Trim().ToLower())
                                {
                                    var sheetImport = new ExcelSheetRawModel
                                    {
                                        SelectedFormId = form.formId,
                                        SheetName = sheet.SheetName,
                                        ApplicationId = customApplicationId,
                                        SheetData = sheet.SheetData,
                                        ImportValidations = new List<GenericFormImportReturnModel>()
                                    };

                                    foreach (var header in sheet.ExcelHeaders)
                                    {
                                        var validation = new GenericFormImportReturnModel()
                                        {
                                            FormHeader = null,
                                            ExcelHeader = header,
                                            IsItGoodToImport = false
                                        };
                                        foreach (var keyPairs in form.formHeaders)
                                        {
                                            if (keyPairs.excelHeader.Trim().ToLower() == header.Trim().ToLower())
                                            {
                                                validation.FormHeader = keyPairs.formHeader;
                                                validation.ExcelHeader = header;
                                                validation.IsItGoodToImport = keyPairs.isItGoodToImport;
                                            }
                                        }
                                        sheetImport.ImportValidations.Add(validation);
                                    }

                                    validatedSheets.FormImports.Add(sheetImport);
                                }
                            }
                        }

                        Console.WriteLine("Submitting the Mapped data into custom application");

                        customApplicationService.ImportVerifiedApplication(validatedSheets, loggedInUser, validationMessages);

                        spreadSheetDocument.Close();

                        if (validationMessages.Count == 0)
                        {
                            Console.WriteLine("Submitting Completed moving " + Path.GetFileName(file) + " to Completed");

                            if (!Directory.Exists(directoryPath + @"\Completed"))
                            {
                                Directory.CreateDirectory(directoryPath + @"\Completed");
                            }

                            string sourceFile = Path.Combine(directoryPath, fileName);
                            string destFile = Path.Combine(directoryPath + @"\Completed\", fileName);

                            // To move a file or folder to a new location:
                            File.Move(sourceFile, destFile);

                            Console.WriteLine("Moved " + Path.GetFileName(file) + " to Completed");
                        }
                    }
                    else
                    {
                        spreadSheetDocument.Close();

                        Console.WriteLine("Mapping not found for File with name " + Path.GetFileName(file));

                        if (!Directory.Exists(directoryPath + @"\Mapping not found"))
                        {
                            Directory.CreateDirectory(directoryPath + @"\Mapping not found");
                        }

                        string sourceFile = Path.Combine(directoryPath, fileName);
                        string destFile = Path.Combine(directoryPath + @"\Mapping not found\", fileName);

                        Console.WriteLine("Moving " + Path.GetFileName(file) + " to Mapping not found");

                        File.Move(sourceFile, destFile);
                    }
                }
                Thread.Sleep(10000);
            }
        }
    }
}
