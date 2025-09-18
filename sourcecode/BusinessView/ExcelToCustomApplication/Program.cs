using System;
using System.Collections.Generic;
using System.Configuration;
using System.Globalization;
using System.IO;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using ClosedXML.Excel;
using Newtonsoft.Json;
using ExcelToCustomApplication.Models;
using ExcelToCustomApplication.Repositories;
using Microsoft.Extensions.DependencyInjection;
using Newtonsoft.Json.Linq;
using System.Data.Common;
using ExcelDataReader;
using System.Data;

class Program
{
    private readonly ExcelToCustomApplicationRepository _excelToCustomApplicationRepository;

    public Program(ExcelToCustomApplicationRepository excelToCustomApplicationRepository)
    {
        _excelToCustomApplicationRepository = excelToCustomApplicationRepository;
    }

    static void Main(string[] args)
    {
        var serviceProvider = new ServiceCollection()
                .AddSingleton<ExcelToCustomApplicationRepository>()
                .AddSingleton<Program>()  // Register Program class
                .BuildServiceProvider();

        var program = serviceProvider.GetService<Program>();

        if (program != null)
        {
            program.Run();
        }
    }

    private void Run()
    {
        while (true)
        {
            try
            {
                List<ExcelSheetDetails> excelSheets = _excelToCustomApplicationRepository.GetExcelSheetDetails();
                if (excelSheets != null && excelSheets.Count > 0)
                {
                    Console.WriteLine("Processing files count : " + excelSheets.Count);

                    foreach (var excelSheet in excelSheets)
                    {
                        ProcessFile(excelSheet);
                    }
                }
                else
                {
                    Console.WriteLine("No excel sheets found");
                }

                // Wait for 10 sec
                System.Threading.Thread.Sleep(10 * (1000));
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                LogMessage(ex.Message);
            }
        }
    } 

    private void ProcessFile(ExcelSheetDetails excelSheet)
    {
        try
        {
            Console.WriteLine($"Processing file: {excelSheet.ExcelPath}");
            LogMessage($"Processing file: {excelSheet.ExcelPath}");

            string excelPath = excelSheet.ExcelPath;
            bool isXlsFile = Path.GetExtension(excelPath).Equals(".xls", StringComparison.OrdinalIgnoreCase);

            if (isXlsFile)
            {
                excelPath = ConvertXlsToXlsx(excelSheet.ExcelPath);
            }

            var jsonDataList = new List<string>();
            bool hasAnyErrorOccurred = false;

            using (var workbook = new XLWorkbook(excelPath))
            {
                var worksheet = workbook.Worksheet(1);
                //var headers = GetHeaders(worksheet);
                int rowCount = worksheet.RowsUsed().Count();

                for (int rowIndex = 2; rowIndex <= rowCount; rowIndex++)
                {
                    try
                    {
                        var jsonDict = GetJsonDict(excelSheet, worksheet, rowIndex);

                        if (jsonDict == null)
                        {
                            hasAnyErrorOccurred = true;
                            Console.WriteLine($"Error occured while getting Json data from records in Excel sheet {excelSheet.ExcelSheetName} ");
                            LogMessage($"Error occured while getting Json data from records in Excel sheet {excelSheet.ExcelSheetName} ");
                            break;
                        }

                        if (!ValidateJsonDict(jsonDict))
                        {
                            hasAnyErrorOccurred = true;
                            break;
                        }

                        jsonDict = AddMetaData(jsonDict, excelSheet);
                        jsonDataList.Add(JsonConvert.SerializeObject(jsonDict, Formatting.Indented));
                    }
                    catch (Exception ex)
                    {
                        hasAnyErrorOccurred = true;
                        Console.WriteLine($"Error processing row {rowIndex}: {ex.Message}");
                        LogMessage($"Error processing row {rowIndex}: {ex.Message}");
                        break;
                    }
                }
            }

            if (hasAnyErrorOccurred)
            {
                HandleError(excelPath, excelSheet, isXlsFile);
            }
            else
            {
                HandleSuccess(excelPath, excelSheet, jsonDataList, isXlsFile);
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error processing file {excelSheet.ExcelSheetName} : {ex.Message}");
            LogMessage($"Error processing file {excelSheet.ExcelSheetName} : {ex.Message}");

        }
    }

    private List<string> GetHeaders(IXLWorksheet worksheet)
    {
        var headers = new List<string>();
        int colIndex = 1;
        while (true)
        {
            var header = worksheet.Cell(1, colIndex).Value.ToString();
            if (string.IsNullOrWhiteSpace(header))
            {
                break;
            }
            headers.Add(header);
            colIndex++;
        }
        return headers;
    }

    private Dictionary<string, object> GetJsonDict(ExcelSheetDetails excelSheet, IXLWorksheet worksheet, int rowIndex)
    {
        try
        {
            if (excelSheet.ExcelSheetName.Contains("Share India"))
            {
                return new Dictionary<string, object>
        {
             {"tradeDate", ConvertToDateTimeString(worksheet.Cell(rowIndex, 1).Value.ToString())},
             {"settlementDate", ConvertToDateTimeString(worksheet.Cell(rowIndex, 2).Value.ToString())},
             {"accountName", worksheet.Cell(rowIndex, 3).Value.ToString() ?? ""},
             {"isin", worksheet.Cell(rowIndex, 4).Value.ToString() ?? ""},
             {"scripName", worksheet.Cell(rowIndex, 5).Value.ToString() ?? ""},
             {"buySell", worksheet.Cell(rowIndex, 6).Value.ToString() ?? ""},
             {"tradeQuantity", worksheet.Cell(rowIndex, 7).Value.ToString() ?? ""},
             {"grossRate", worksheet.Cell(rowIndex, 8).Value.ToString() ?? ""},
             {"brokerageRate", worksheet.Cell(rowIndex, 9).Value.ToString() ?? ""},
             {"netRate", worksheet.Cell(rowIndex, 10).Value.ToString() ?? ""},
             {"exchange", worksheet.Cell(rowIndex, 11).Value.ToString() ?? ""},
             {"grossAmount", worksheet.Cell(rowIndex, 12).Value.ToString() ?? ""},
             {"brokerageAmount", worksheet.Cell(rowIndex, 13).Value.ToString() ?? ""},
             {"gst", worksheet.Cell(rowIndex, 14).Value.ToString() ?? ""},
             {"securityTransTax", worksheet.Cell(rowIndex, 15).Value.ToString() ?? ""},
             {"otherCharges", worksheet.Cell(rowIndex, 16).Value.ToString() ?? ""},
             {"settlementAmount", worksheet.Cell(rowIndex, 17).Value.ToString() ?? ""},
             {"submit", true},
            };
            }
            else if (excelSheet.ExcelSheetName.Contains("ICICI"))
            {
                return new Dictionary<string, object>
        {
              {"date", ConvertToDateTimeString(worksheet.Cell(rowIndex, 1).Value.ToString()) ?? ""},
              {"reportGeneratedAsOfHoldingDate", ConvertToDateTimeString(worksheet.Cell(rowIndex, 2).Value.ToString()) ?? ""},
              {"clientCodeSp", worksheet.Cell(rowIndex, 3).Value.ToString()?? ""},
              {"clientName", worksheet.Cell(rowIndex, 4).Value.ToString()?? ""},
              {"masterAccountCode", worksheet.Cell(rowIndex, 5).Value.ToString() ?? ""},
              {"schemeAccountCode", worksheet.Cell(rowIndex, 6).Value.ToString() ?? ""},
              {"instrumentName", worksheet.Cell(rowIndex, 7).Value.ToString() ?? ""},
              {"instrumentSubType", worksheet.Cell(rowIndex, 8).Value.ToString() ?? ""},
              {"isinCode", worksheet.Cell(rowIndex, 9).Value.ToString() ?? ""},
              {"clientInstrumentCode", worksheet.Cell(rowIndex, 10).Value.ToString() ?? ""},
              {"instrumentCode", worksheet.Cell(rowIndex, 11).Value.ToString() ?? ""},
              {"pendingPurchase", worksheet.Cell(rowIndex, 12).Value.ToString() ?? ""},
              {"pendingSales", worksheet.Cell(rowIndex, 13).Value.ToString() ?? ""},
              {"pendingBlockedQty", worksheet.Cell(rowIndex, 14).Value.ToString() ?? ""},
              {"totalPhysicalSaleable", worksheet.Cell(rowIndex, 15).Value.ToString() ?? ""},
              {"totalDematSaleableNet", worksheet.Cell(rowIndex, 16).Value.ToString() ?? ""},
              {"totalSaleable", worksheet.Cell(rowIndex, 17).Value.ToString() ?? ""},
              {"bookPosition", worksheet.Cell(rowIndex, 18).Value.ToString() ?? ""},
              {"rate", worksheet.Cell(rowIndex, 19).Value.ToString() ?? ""},
              {"dateOfRate", ConvertToDateTimeString(worksheet.Cell(rowIndex, 20).Value.ToString()) ?? ""},
              {"registeredStock", worksheet.Cell(rowIndex, 21).Value.ToString() ?? ""},
              {"openLotNse", worksheet.Cell(rowIndex, 22).Value.ToString() ?? ""},
              {"valueOfRegisteredStock", worksheet.Cell(rowIndex, 23).Value.ToString() ?? ""},
              {"submit", true},
            };
            }

            // Add other formats if needed
            return null;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error in GetJsonDict of file {excelSheet.ExcelSheetName}: {ex.Message}");
            LogMessage($"Error in GetJsonDict of file {excelSheet.ExcelSheetName}: {ex.Message}");
            return null;
        }
    }

    private bool ValidateJsonDict(Dictionary<string, object> jsonDict)
    {
        try
        {
            foreach (var field in jsonDict)
            {
                if (field.Value == null || (field.Value is string str && string.IsNullOrWhiteSpace(str)))
                {
                    Console.WriteLine("In Excel sheet value of {0} field is empty", field.Key);
                    return false;
                }
            }
            return true;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error ValidateJsonDict : {ex.Message}");
            LogMessage($"Error ValidateJsonDict : {ex.Message}");

            return true;
        }
    }

    private Dictionary<string, object> AddMetaData(Dictionary<string, object> jsonDict, ExcelSheetDetails excelSheet)
    {
        try
        {
            jsonDict.Add("Created User", excelSheet.CreatedUserName);
            jsonDict.Add("Created Date", DateTime.Now.ToString("dd MMM yyyy hh:mm tt"));
            jsonDict.Add("createdBy", excelSheet.CreatedUserId);
            jsonDict.Add("Updated User", "");
            jsonDict.Add("Updated Date", "");
            jsonDict.Add("updatedBy", "");
            return jsonDict;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error AddMetaData to file {excelSheet.ExcelSheetName} : {ex.Message}");
            LogMessage($"Error in GetJsonDict to file  {excelSheet.ExcelSheetName}  : {ex.Message}");
            return null;
        }
    }

    private void HandleError(string excelPath, ExcelSheetDetails excelSheet, bool isXlsFile)
    {
        try
        {
            if (isXlsFile)
            {
                File.Delete(excelPath);
            }

            if (!string.IsNullOrEmpty(excelSheet.ExcelSheetErrorFolder))
            {
                if (!Directory.Exists(excelSheet.ExcelSheetErrorFolder))
                {
                    Directory.CreateDirectory(excelSheet.ExcelSheetErrorFolder);
                }
                string errorFilePath = Path.Combine(excelSheet.ExcelSheetErrorFolder, Path.GetFileName(excelSheet.ExcelSheetName));
                File.Move(excelSheet.ExcelPath, errorFilePath, true);
                Console.WriteLine($"Moved file to error folder: {errorFilePath}");

                var excelToCustomApplicationDetails = new ExcelSheetDetailsInputModel
                {
                    ExcelSheetName = excelSheet.ExcelSheetName,
                    FilePath = excelSheet.ExcelPath,
                    CompanyId = excelSheet.CompanyId,
                    UserId = excelSheet.CreatedUserId,
                    MailAddress = null,
                    IsHavingErrors = true,
                    IsUploaded = false,
                    NeedManualCorrection = false,
                    UpdateRecord = true
                };

                UpsertExcelToCustomApplicationDetails(excelToCustomApplicationDetails, excelSheet.AuthToken);
            }
            else
            {
                Console.WriteLine("Provide the ExcelSheetErrorFolder , which is empty here");
                LogMessage("Provide the ExcelSheetErrorFolder , which is empty here");

            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error in HandleError: {ex.Message}");
            LogMessage($"Error in HandleError: {ex.Message}");
        }
    }

    private void HandleSuccess(string excelPath, ExcelSheetDetails excelSheet, List<string> jsonDataList, bool isXlsFile)
    {
        try
        {
            if (isXlsFile)
            {
                File.Delete(excelPath);
            }

            var inputModel = new GenericFormSubmittedFromExcelInputModel
            {
                UserId = excelSheet.CreatedUserId,
                CompanyId = excelSheet.CompanyId,
                CustomApplicationId = excelSheet.CustomApplicationId,
                FormId = excelSheet.FormId,
                FormJson = jsonDataList,
                ExcelSheetName = excelSheet.ExcelSheetName
            };

            UpsertGenericFormSubmittedFromExcel(inputModel, excelSheet, excelSheet.AuthToken);
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error in handling success: {ex.Message}");
            LogMessage($"Error in handling success: {ex.Message}");
        }
    }

    private string ConvertXlsToXlsx(string xlsPath)
    {
        try
        {
            // Ensure ExcelDataReader works with the correct configuration
            System.Text.Encoding.RegisterProvider(System.Text.CodePagesEncodingProvider.Instance);

            using (var stream = File.Open(xlsPath, FileMode.Open, FileAccess.Read))
            {
                using (var reader = ExcelReaderFactory.CreateReader(stream))
                {
                    var dataSet = reader.AsDataSet(new ExcelDataSetConfiguration()
                    {
                        ConfigureDataTable = _ => new ExcelDataTableConfiguration()
                        {
                            UseHeaderRow = true
                        }
                    });

                    string xlsxPath = Path.ChangeExtension(xlsPath, ".xlsx");
                    using (var workbook = new XLWorkbook())
                    {
                        foreach (DataTable table in dataSet.Tables)
                        {
                            var worksheet = workbook.Worksheets.Add(table.TableName);

                            // Adding column names
                            for (int col = 0; col < table.Columns.Count; col++)
                            {
                                worksheet.Cell(1, col + 1).Value = table.Columns[col].ColumnName.ToString();
                            }

                            // Adding rows
                            for (int row = 0; row < table.Rows.Count; row++)
                            {
                                for (int col = 0; col < table.Columns.Count; col++)
                                {
                                    worksheet.Cell(row + 2, col + 1).Value = table.Rows[row][col]?.ToString();
                                }
                            }
                        }

                        workbook.SaveAs(xlsxPath);
                    }

                    return xlsxPath;
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error occurred while converting xls to xlsx : {ex.Message}");
            LogMessage($"Error occurred while converting xls to xlsx : {ex.Message}");
            return null;
        }
    }

    public static string ConvertToDateTimeString(string dateStr)
    {
        string[] formats = {
            "dd/MM/yyyy HH:mm:ss",
            "dd-MM-yyyy HH:mm:ss",
            "yyyy-MM-ddTHH:mm:ss.fff",
            "yyyy-MM-ddTHH:mm:ss",
            "yyyy-MM-dd HH:mm:ss",
            "dd/MM/yyyy",
            "dd-MM-yyyy",
            "yyyy-MM-dd",
            "dd-MMM-yy",    
            "dd MMM yy"     
        };

        if (DateTime.TryParseExact(dateStr.Trim(), formats, CultureInfo.InvariantCulture, DateTimeStyles.None, out DateTime dateValue))
        {
            return dateValue.ToString("yyyy-MM-ddTHH:mm");
        }
        else
        {
            throw new FormatException($"Invalid date format: {dateStr}");
        }
    }

    private void UpsertGenericFormSubmittedFromExcel(GenericFormSubmittedFromExcelInputModel inputModel, ExcelSheetDetails excelSheet, string authToken)
    {
        try
        {
            var sqlInputModel = new DailyUploadExcelsInputModel
            {
                ExcelSheetName = inputModel?.ExcelSheetName,
                IsUploaded = true,
                IsHavingErrors = false,
                NeedManualCorrection = false,
                ErrorText = string.Empty
            };

            if (inputModel != null && inputModel.FormJson != null && inputModel.FormJson.Count > 0)
            {
                var errorRowNumbers = new List<int>();
                int rowIndex = 0;
                var errorText = string.Empty;

                foreach (var data in inputModel.FormJson)
                {
                    rowIndex++;
                    var id = Guid.NewGuid();

                    try
                    {
                        var dataSetUpsertInputModel = new DataSetUpsertInputModel
                        {
                            IsArchived = false,
                            CompanyId = inputModel.CompanyId,
                            CreatedByUserId = inputModel.UserId,
                            DataSourceId = inputModel.FormId,
                            Id = id,
                            IsNewRecord = true,
                            DataJson = JsonConvert.SerializeObject(new DataSetConversionModel
                            {
                                CustomApplicationId = inputModel.CustomApplicationId,
                                ContractType = "Form",
                                InvoiceType = "CustomApplication",
                                FormData = JsonConvert.DeserializeObject<object>(data)
                            })
                        };
                        //inputModel.GenericFormSubmittedId = await _dataSetService.CreateDataSetGeneriForm(dataSetUpsertInputModel, loggedInContext, validationMessages);
                        inputModel.GenericFormSubmittedId = CreateDataSetGeneriForm(dataSetUpsertInputModel, authToken);
                        var submissionId = id;

                    }
                    catch (Exception exception)
                    {
                        errorRowNumbers.Add(rowIndex);
                        Console.WriteLine("Exception in UpsertGenericFormSubmittedFromExcel : " + exception);
                        LogMessage("Exception in UpsertGenericFormSubmittedFromExcel : " + exception);
                    }
                }
                var excelDetails = new ExcelSheetDetailsInputModel();
                if (errorRowNumbers.Count > 0)
                {
                    sqlInputModel.IsHavingErrors = true;
                    sqlInputModel.ErrorText = $"Rows with errors: {string.Join(",", errorRowNumbers)}";
                    Console.WriteLine(sqlInputModel.ErrorText);
                    LogMessage(sqlInputModel.ErrorText);
                    excelDetails = new ExcelSheetDetailsInputModel
                    {
                        ExcelSheetName = excelSheet.ExcelSheetName,
                        FilePath = excelSheet.ExcelPath,
                        CompanyId = excelSheet.CompanyId,
                        UserId = excelSheet.CreatedUserId,
                        MailAddress = null,
                        IsHavingErrors = false,
                        IsUploaded = false,
                        NeedManualCorrection = true,
                        UpdateRecord = true
                    };
                }
                else
                {
                    Console.WriteLine("Successfully inserted the excel sheet {0} to custom application records." , excelSheet.ExcelSheetName);
                    LogMessage($"Successfully inserted the excel sheet {excelSheet.ExcelSheetName} to custom application records." );

                    excelDetails = new ExcelSheetDetailsInputModel
                    {
                        ExcelSheetName = excelSheet.ExcelSheetName,
                        FilePath = excelSheet.ExcelPath,
                        CompanyId = excelSheet.CompanyId,
                        UserId = excelSheet.CreatedUserId,
                        MailAddress = null,
                        IsHavingErrors = false,
                        IsUploaded = false,
                        NeedManualCorrection = false,
                        UpdateRecord = true
                    };
                }

                if (!string.IsNullOrEmpty(excelSheet.ExcelSheetProcessedFolder))
                {
                    if (!Directory.Exists(excelSheet.ExcelSheetProcessedFolder))
                    {
                        Directory.CreateDirectory(excelSheet.ExcelSheetProcessedFolder);
                    }

                    // Move the file to the destination folder
                    string processedFilePath = Path.Combine(excelSheet.ExcelSheetProcessedFolder, Path.GetFileName(excelSheet.ExcelSheetName));

                    File.Move(excelSheet.ExcelPath, processedFilePath, true);

                    Console.WriteLine($"File moved to: {processedFilePath}");
                    LogMessage($"File moved to: {processedFilePath}");
                }
                else
                {
                    Console.WriteLine("Provide the ExcelSheetProcessedFolder , which is empty here");
                    LogMessage("Provide the ExcelSheetProcessedFolder , which is empty here");
                }

                var excelToCustomApplicationDetails = new ExcelSheetDetailsInputModel
                {
                    ExcelSheetName = excelSheet.ExcelSheetName,
                    FilePath = excelSheet.ExcelPath,
                    CompanyId = excelSheet.CompanyId,
                    UserId = excelSheet.CreatedUserId,
                    MailAddress = null,
                    IsHavingErrors = false,
                    IsUploaded = true,
                    NeedManualCorrection = false,
                    UpdateRecord = true
                };

                UpsertExcelToCustomApplicationDetails(excelToCustomApplicationDetails, excelSheet.AuthToken);
            }
        }
        catch (Exception exception)
        {
            Console.WriteLine("Exception in UpsertGenericFormSubmittedFromExcel : " + exception);
            LogMessage("Exception in UpsertGenericFormSubmittedFromExcel : " + exception);
        }
    }
    private void UpsertExcelToCustomApplicationDetails(ExcelSheetDetailsInputModel inputModel, string authToken)
    {
        try
        {
            var excelSheetDetails = new DailyUploadExcelsInputModel
            {
                ExcelSheetName = inputModel.ExcelSheetName,
                MailAddress = inputModel.MailAddress,
                FilePath = inputModel.FilePath,
                CustomApplicationId = null,
                FormId = null,
                IsUploaded = inputModel.IsUploaded,
                IsHavingErrors = inputModel.IsHavingErrors,
                NeedManualCorrection = inputModel.NeedManualCorrection,
                UserId = inputModel.UserId,
                CompanyId = inputModel.CompanyId,
                AuthToken = authToken
            };
            var result = _excelToCustomApplicationRepository.UpsertExcelToCustomApplicationDetails(excelSheetDetails);
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error in UpsertExcelToCustomApplicationDetails : {ex}");
            LogMessage($"Error in UpsertExcelToCustomApplicationDetails : {ex}");
        }
    }

    public Guid CreateDataSetGeneriForm(DataSetUpsertInputModel dataSetUpsertInputModel, string authToken)
    {
        try
        {
            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri(ConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/CreateDataSet");

                client.Timeout = TimeSpan.FromSeconds(300);  // Set the timeout to 300 seconds
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", authToken);
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

                HttpRequestMessage request = new HttpRequestMessage(HttpMethod.Post, client.BaseAddress)
                {
                    Content = new StringContent(JsonConvert.SerializeObject(dataSetUpsertInputModel), Encoding.UTF8, "application/json")
                };

                HttpResponseMessage response = client.Send(request);

                if (response.IsSuccessStatusCode)
                {
                    string result = response.Content.ReadAsStringAsync().Result;
                    string data = JsonConvert.DeserializeObject<DataServiceOutputModel>(result).Data.ToString();
                    return new Guid(data);
                }
                else
                {
                    Console.WriteLine("Error occurred while calling API CreateDataSet: " + response.ToString());
                    LogMessage("Error occurred while calling API CreateDataSet: " + response.ToString());
                    return Guid.Empty;
                }
            }
        }
        catch (Exception exception)
        {
            Console.WriteLine($"Error in CreateDataSetGeneriForm: {exception}");
            LogMessage($"Error in CreateDataSetGeneriForm: {exception}");
            return Guid.Empty;
        }
    }

    private void LogMessage(string message)
    {
        try
        {
            string filePath = ConfigurationManager.AppSettings["ErrorLogFilePath"];
            // Ensure the directory exists
            string directory = Path.GetDirectoryName(filePath);
            if (!Directory.Exists(directory))
            {
                Directory.CreateDirectory(directory);
            }

            // Create the log file if it doesn't exist
            if (!File.Exists(filePath))
            {
                using (FileStream fs = File.Create(filePath)) { }
            }

            // Write the error message to the log file
            using (StreamWriter writer = new StreamWriter(filePath, true))
            {
                writer.WriteLine($"[{DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")}] {message}");
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error logging to file : {ex.Message}");
        }
    }
}
