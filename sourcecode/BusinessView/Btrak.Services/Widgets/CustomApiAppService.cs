using Btrak.Dapper.Dal.Partial;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.CompanyStructure;
using Btrak.Models.MasterData;
using Btrak.Models.SystemManagement;
using Btrak.Models.TestRail;
using Btrak.Models.TradeManagement;
using Btrak.Models.Widgets;
using Btrak.Services.Chromium;
using Btrak.Services.CompanyStructure;
using Btrak.Services.Email;
using Btrak.Services.FileUploadDownload;
using Btrak.Services.Helpers;
using BTrak.Common;
using DocumentFormat.OpenXml;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.Azure;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web;
using System.Web.Hosting;
using static BTrak.Common.Enumerators;

namespace Btrak.Services.Widgets
{
    public class CustomApiAppService : ICustomApiAppService
    {
        private readonly WidgetRepository _widgetRepository = new WidgetRepository();
        private readonly GoalRepository _goalRepository = new GoalRepository();
        private readonly UserRepository _userRepository;
        private readonly IWidgetService _widgetService;
        private readonly IEmailService _emailService;
        private readonly IChromiumService _chromiumService;
        private readonly MasterDataManagementRepository _masterDataManagementRepository;
        private readonly ICompanyStructureService _companyStructureService;
        private readonly IFileStoreService _fileStoreService;
        private DateTime? _dateFrom;
        private DateTime? _dateTo;
        private DateTime? _date;

        public CustomApiAppService(UserRepository userRepository, IFileStoreService fileStoreService, IWidgetService widgetService, ICompanyStructureService companyStructureService, IEmailService emailService, ChromiumService chromiumService, MasterDataManagementRepository masterDataManagementRepository)
        {
            _widgetService = widgetService;
            _userRepository = userRepository;
            _masterDataManagementRepository = masterDataManagementRepository;
            _chromiumService = chromiumService;
            _emailService = emailService;
            _fileStoreService = fileStoreService;
            _companyStructureService = companyStructureService;
        }

        public async Task<ApiOutputDataModel> GetApiData(CustomApiAppInputModel customApiAppInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            HttpClient client = new HttpClient();

            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
            client.DefaultRequestHeaders.Accept.Clear();

            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

            if (!string.IsNullOrEmpty(customApiAppInputModel.ApiHeadersJson))
            {
                customApiAppInputModel.ApiHeaders = JsonConvert.DeserializeObject<ApiHeadersModel[]>(customApiAppInputModel.ApiHeadersJson);
            }

            foreach (var header in customApiAppInputModel.ApiHeaders)
            {
                if (header.Key?.Trim().ToLower() == "cache-control")
                {
                    client.DefaultRequestHeaders.Add("Cache-Control", "no-cache");
                }
                else if (header.Key?.Trim().ToLower() == "content-type")
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                }
                else
                {
                    client.DefaultRequestHeaders.Add(header.Key, header.Value);
                }
            }

            List<FilterKeyValuePair> filters = new List<FilterKeyValuePair>();

            if (customApiAppInputModel.IsForDashBoard == true && customApiAppInputModel.DashboardId != null && customApiAppInputModel.WorkspaceId != null)
            {
                DynamicDashboardFilterModel dashboardFilterModel = new DynamicDashboardFilterModel
                {
                    DashboardAppId = customApiAppInputModel.DashboardId,
                    DashboardId = customApiAppInputModel.WorkspaceId
                };

                filters = _widgetRepository.GetDashboardFilters(dashboardFilterModel, loggedInContext, validationMessages);
            }

            if (customApiAppInputModel.ApiUrl.Contains('@'))
            {
                customApiAppInputModel.ApiUrl = RepalceFilterParams(customApiAppInputModel.ApiUrl, loggedInContext, filters);
            }
            DashboardAPIInputModel dashboardAPIInputModel = new DashboardAPIInputModel();
            if (customApiAppInputModel.BodyJson.Contains('@') || filters.Count > 0 )
            {
                customApiAppInputModel.BodyJson = RepalceFilterParams(customApiAppInputModel.BodyJson, loggedInContext, filters);
                string filter = filters?.Where(t => t.FilterKey == "Date")?.FirstOrDefault().FilterValue;

                DateFilterModel dateFilterModel = new DateFilterModel();
            

                if (dateFilterModel != null)
                {
                    dateFilterModel = JsonConvert.DeserializeObject<DateFilterModel>(filter);
                    dashboardAPIInputModel.DateFrom = dateFilterModel.DateFrom;
                    dashboardAPIInputModel.DateTo = dateFilterModel.DateTo;
                }

                customApiAppInputModel.BodyJson = JsonConvert.SerializeObject(dashboardAPIInputModel);
                
            }

            string outputResult = string.Empty;
            HttpResponseMessage response = new HttpResponseMessage();

            if (customApiAppInputModel.HttpMethod == "GET")
            {
                response = await client.GetAsync(customApiAppInputModel.ApiUrl);
            }
            else if (customApiAppInputModel.HttpMethod == "POST")
            {
                HttpContent content = new StringContent(JsonConvert.SerializeObject(dashboardAPIInputModel), Encoding.UTF8, "application/json");

                response = await  client.PostAsync(customApiAppInputModel.ApiUrl , content);

            }

            response.EnsureSuccessStatusCode();

            List<string> outputRouteParams = new List<string>();

            if (!string.IsNullOrEmpty(customApiAppInputModel.OutputRoot))
            {
                outputRouteParams = customApiAppInputModel.OutputRoot.Split(',').ToList();
            }

            if (response.IsSuccessStatusCode)
            {
                var dataObjects = response.Content.ReadAsAsync<Object>().Result;  //Make sure to add a reference to System.Net.Http.Formatting.dll

                if (string.IsNullOrEmpty(customApiAppInputModel.OutputRoot))
                {
                    outputResult = dataObjects.ToString();
                }
                else
                {
                    JObject data = JsonConvert.DeserializeObject<JObject>(dataObjects.ToString());
                    foreach (var prop in data.Properties())
                    {
                        if (prop.Name == outputRouteParams.LastOrDefault())
                        {
                            outputResult = prop.Value.ToString();
                            break;
                        }
                    }
                }
            }

            ApiOutputDataModel apiOutputDataModel = new ApiOutputDataModel()
            {
                ApiData = outputResult.ToString()
            };

            if (customApiAppInputModel.IsForDashBoard == true)
            {
                CustomWidgetSearchCriteriaInputModel widgetSearchCriteriaInputModel = new CustomWidgetSearchCriteriaInputModel();

                widgetSearchCriteriaInputModel.CustomWidgetId = customApiAppInputModel.CustomWidgetId;

                var customWidgetData = _widgetService.GetCustomWidgets(widgetSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();

                apiOutputDataModel.CustomWidgetName = customWidgetData.CustomWidgetName;

                apiOutputDataModel.AllChartsDetails = customWidgetData.AllChartsDetails;
            }

            return apiOutputDataModel;
        }

        public Guid? UpsertCustomAppApiDetails(CustomApiAppInputModel customApiAppInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCustomWidgetApiDetails", "CustomApiAppInputModel", customApiAppInputModel, "CustomApiAppService"));

            if (!WidgetsValidationHelpers.UpsertCustomWidgetApiDetailsValidators(customApiAppInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            if (customApiAppInputModel.ApiHeaders != null && customApiAppInputModel.ApiHeaders.Length > 0)
            {
                customApiAppInputModel.ApiHeadersJson = JsonConvert.SerializeObject(customApiAppInputModel.ApiHeaders);
            }

            if (customApiAppInputModel.OutputParams != null && customApiAppInputModel.OutputParams.Length > 0)
            {
                customApiAppInputModel.ApiOutputsJson = JsonConvert.SerializeObject(customApiAppInputModel.OutputParams);
            }

            return _widgetRepository.UpsertCustomAppApiDetails(customApiAppInputModel, loggedInContext, validationMessages);
        }

        public CustomApiAppInputModel GetCustomAppApiDetails(CustomApiAppInputModel customApiAppInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCustomWidgetApiDetails", "CustomApiAppInputModel", customApiAppInputModel, "CustomApiAppService"));


            CustomApiAppInputModel customApiAppOutputModel = _widgetRepository.GetCustomAppApiDetails(customApiAppInputModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (!string.IsNullOrEmpty(customApiAppOutputModel.ApiHeadersJson))
            {
                customApiAppOutputModel.ApiHeaders = JsonConvert.DeserializeObject<ApiHeadersModel[]>(customApiAppOutputModel.ApiHeadersJson);
            }

            if (!string.IsNullOrEmpty(customApiAppOutputModel.ApiOutputsJson))
            {
                customApiAppOutputModel.OutputParams = JsonConvert.DeserializeObject<ApiOutputModel[]>(customApiAppOutputModel.ApiOutputsJson);
            }

            return customApiAppOutputModel;
        }
        public async Task<bool> SendWidgetReportEmail(SendWidgetReportModel sendWidgetReportModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SendWidgetReportEmail", "sendWidgetReportModel", sendWidgetReportModel, "CustomApiAppService"));
            List<StreamWithType> fileStreamsList = new List<StreamWithType>();
            CompanyOutputModel companyModel = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);
            if (sendWidgetReportModel.FileExtension == ".xlsx")
            {
                //string[] columnIndex = new string[] { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z","AA","AB","AC","AD","AE","AF" };
                List<string> excelColumns = new List<string>();
                List<string> excelFields = new List<string>();

                foreach (var value in sendWidgetReportModel.Columns)
                {
                    if (value.Hidden != true)
                    {
                        excelColumns.Add(sendWidgetReportModel.IsFromProcessApp ? value.Title : value.ColumnAltName);
                        excelFields.Add(value.Field);
                    }
                }
                var path = HostingEnvironment.MapPath(@"~/Resources/ExcelTemplates/CustomWidgetReport.xlsx");
                var path1 = HostingEnvironment.MapPath(@"~/Resources/ExcelTemplates"); 
                var guid = Guid.NewGuid();
                var destinationPath = Path.Combine(path1, guid.ToString());
                string docName = Path.Combine(destinationPath, "CustomWidgetReport.xlsx");
                if (!Directory.Exists(destinationPath))
                {
                    Directory.CreateDirectory(destinationPath);

                    if (path != null)
                    {
                        System.IO.File.Copy(path, docName, true);
                    }

                    LoggingManager.Info("Created a directory to save temp file");
                }

                var columLength = excelColumns.Count();
                using (SpreadsheetDocument spreadSheet = SpreadsheetDocument.Open(docName, true))
                {
                    uint rowIndex = 0;
                    Cell prevCol = new Cell();
                    Cell prevCellValue = new Cell();

                    for (int i = 0; i < columLength; i++)
                    {
                        string str = "";
                        char achar;
                        int mod;
                        var num = i;
                        while (true)
                        {
                            mod = (num % 26) + 65;
                            num = (int)(num / 26);
                            achar = (char)mod;
                            str = achar + str;
                            if (num > 0) num--;
                            else if (num == 0) break;
                        }
                        //if (i<28)
                        {
                            prevCol = AddUpdateCellValue(spreadSheet, "WidgetReport", 0, str, excelColumns[i], prevCol != null? prevCol :null);
                        }
                    }
                    rowIndex = 1;
                    uint index = 0;
                    foreach (var data in sendWidgetReportModel.Data)
                    {
                        index = 0;

                        JObject dataProperties = (JObject)JsonConvert.DeserializeObject(data.ToString());
                        Dictionary<string, string> keyValueMap1 = new Dictionary<string, string>();

                        foreach (KeyValuePair<string, JToken> keyValuePair in dataProperties)
                        {
                            keyValueMap1.Add(keyValuePair.Key, keyValuePair.Value.ToString());
                        }

                        for (int i = 0; i < columLength; i++)
                        {
                            foreach (var keyValue in keyValueMap1)
                            {
                                if (keyValue.Key == excelFields[i])
                                {
                                    string str = "";
                                    char achar;
                                    int mod;
                                    var num = i;
                                    while (true)
                                    {
                                        mod = (num % 26) + 65;
                                        num = (int)(num / 26);
                                        achar = (char)mod;
                                        str = achar + str;
                                        if (num > 0) num--;
                                        else if (num == 0) break;
                                    }
                                    prevCellValue = AddUpdateCellValue(spreadSheet, "WidgetReport", rowIndex, str, keyValue.Value, prevCellValue != null ? prevCellValue : null);
                                }
                            }
                        }
                        prevCellValue = new Cell();
                        rowIndex++;
                    }

                    spreadSheet.Close();

                    var inputBytes = System.IO.File.ReadAllBytes(docName);

                    //var blobUrl = _fileStoreService.PostFile(new FilePostInputModel
                    //{
                    //    MemoryStream = System.IO.File.ReadAllBytes(docName),
                    //    FileName = sendWidgetReportModel.FileName + ".xlsx",
                    //    ContentType = "application/xlsx",
                    //    LoggedInUserId = loggedInContext.LoggedInUserId
                    //});
                    //Stream fileStream = new MemoryStream(inputBytes);
                    var webClient = new WebClient();
                    //byte[] fileBytes = webClient.DownloadData(blobUrl);
                    Stream stream = new MemoryStream(inputBytes);
                    List<StreamWithType> fileStream = new List<StreamWithType>();
                    fileStreamsList.Add(new StreamWithType() { FileStream = stream, FileName = sendWidgetReportModel.FileName, FileType = ".xlsx", IsExcel = true });
                    //fileStreamsList.Add(new StreamWithType() { FileStream = fileStream, FileName = sendWidgetReportModel.FileName, FileType = sendWidgetReportModel.FileExtension, IsPdf = false });

                }
            }
            else  if (sendWidgetReportModel.ReportType == "queryReport")
            {
                string base64 = sendWidgetReportModel.File.Substring(sendWidgetReportModel.File.IndexOf(',') + 1);
                byte[] bytes = Convert.FromBase64String(base64);
                Stream fileStream = new MemoryStream(bytes);
                fileStreamsList.Add(new StreamWithType() { FileStream = fileStream, FileName = sendWidgetReportModel.FileName, FileType = ".pdf", IsPdf = true });
            }
            else if (sendWidgetReportModel.ReportType == "htmlReport")
            {
                var companySettingsSearchInputModel = new CompanySettingsSearchInputModel();
                companySettingsSearchInputModel.CompanyId = loggedInContext.CompanyGuid;
                companySettingsSearchInputModel.IsSystemApp = null;
                string storageAccountName = string.Empty;

                var PdfOutput = await _chromiumService.GenerateExecutionPdf(sendWidgetReportModel.File, sendWidgetReportModel.FileName, null).ConfigureAwait(false);

                List<CompanySettingsSearchOutputModel> companySettings = _masterDataManagementRepository.GetCompanySettings(companySettingsSearchInputModel, loggedInContext, validationMessages).ToList();
                if (companySettings.Count > 0)
                {
                    var storageAccountDetails = companySettings.Where(x => x.Key == "StorageAccountName").FirstOrDefault();
                    storageAccountName = storageAccountDetails?.Value;
                }

                var directory = SetupCompanyFileContainer(companyModel, 6, loggedInContext.LoggedInUserId, storageAccountName);

                var ContractFileName = sendWidgetReportModel.FileName;

                var fileExtension = ".pdf";

                var ContractConvertedFileName = ContractFileName + fileExtension;

                CloudBlockBlob ContractConvertedBlockBlob = directory.GetBlockBlobReference(ContractConvertedFileName);

                ContractConvertedBlockBlob.Properties.CacheControl = "public, max-age=2592000";

                ContractConvertedBlockBlob.Properties.ContentType = "application/pdf";

                Byte[] ContractBytes = PdfOutput.ByteStream;

                ContractConvertedBlockBlob.UploadFromByteArray(ContractBytes, 0, ContractBytes.Length);
                string pdf = ContractConvertedBlockBlob.Uri.AbsoluteUri;

                var webClient = new WebClient();
                byte[] fileBytes = webClient.DownloadData(pdf);
                Stream stream = new MemoryStream(fileBytes);
                List<StreamWithType> fileStream = new List<StreamWithType>();
                fileStreamsList.Add(new StreamWithType() { FileStream = stream, FileName = sendWidgetReportModel.FileName, FileType = ".pdf", IsPdf = true });

            }
            SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, companyModel.SiteAddress);

            try
            {
                var toMails = sendWidgetReportModel.ToEmails;
                EmailGenericModel emailModel = new EmailGenericModel
                {
                    SmtpServer = smtpDetails?.SmtpServer,
                    SmtpServerPort = smtpDetails?.SmtpServerPort,
                    SmtpMail = smtpDetails?.SmtpMail,
                    SmtpPassword = smtpDetails?.SmtpPassword,
                    ToAddresses = toMails,
                    HtmlContent = sendWidgetReportModel.Body,
                    Subject = sendWidgetReportModel.Subject,
                    CCMails = null,
                    BCCMails = null,
                    MailAttachmentsWithFileType = fileStreamsList,
                    IsPdf = null
                };
                _emailService.SendMail(loggedInContext, emailModel);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ShareCustomReportTemplate", "Widget Api", exception));
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.MailNotSend)
                });
            }
            return true;
        }

        private static CellFormat GetCellFormat(WorkbookPart workbookPart, uint styleIndex)
        {
            return workbookPart.WorkbookStylesPart.Stylesheet.Elements<CellFormats>().First().Elements<CellFormat>().ElementAt((int)styleIndex);
        }

        private static uint InsertFont(WorkbookPart workbookPart, Font font)
        {
            Fonts fonts = workbookPart.WorkbookStylesPart.Stylesheet.Elements<Fonts>().First();
            // ReSharper disable once PossiblyMistakenUseOfParamsMethod
            if (font != null) fonts.Append(font);
            return fonts.Count++;
        }

        private static Font GenerateFont(int fontSize = 11, Color color = null)
        {
            var font = new Font(new FontSize { Val = fontSize }, new Bold(), color);
            if (color != null)
                font.Color = color;
            return font;
        }

        private static uint InsertCellFormat(WorkbookPart workbookPart, CellFormat cellFormat)
        {
            CellFormats cellFormats = workbookPart.WorkbookStylesPart.Stylesheet.Elements<CellFormats>().First();
            // ReSharper disable once PossiblyMistakenUseOfParamsMethod
            if (cellFormat != null) cellFormats.Append(cellFormat);
            return cellFormats.Count++;
        }
        private Cell AddUpdateCellValue(SpreadsheetDocument spreadSheet, string sheetname, uint rowIndex, string columnName, string text,Cell preCell)
        {
            // Opening document for editing            
            WorksheetPart worksheetPart =
             RetrieveSheetPartByName(spreadSheet, sheetname);
            if (worksheetPart != null)
            {
                Cell cell = InsertCellInSheet(columnName, (rowIndex + 1), worksheetPart,preCell);
                cell.CellValue = new CellValue(text);
                if (rowIndex == 0)
                {
                    CellFormat cellFormat = cell.StyleIndex != null ? GetCellFormat(spreadSheet.WorkbookPart, cell.StyleIndex).CloneNode(true) as CellFormat : new CellFormat();
                    cellFormat.FontId = InsertFont(spreadSheet.WorkbookPart, GenerateFont(11));
                    cell.StyleIndex = InsertCellFormat(spreadSheet.WorkbookPart, cellFormat);
                }
                //cell datatype     
                cell.DataType = new EnumValue<CellValues>(CellValues.String);
                // Save the worksheet.            
                worksheetPart.Worksheet.Save();

                return cell;
            }
            return null;
        }

        //retrieve sheetpart            
        private WorksheetPart RetrieveSheetPartByName(SpreadsheetDocument document, string sheetName)
        {
            IEnumerable<Sheet> sheets =
             document.WorkbookPart.Workbook.GetFirstChild<Sheets>().
            Elements<Sheet>().Where(s => s.Name == sheetName);
            if (sheets.Count() == 0)
            {
                return null;
            }

            string relationshipId = sheets.First().Id.Value;
            WorksheetPart worksheetPart = (WorksheetPart)
            document.WorkbookPart.GetPartById(relationshipId);
            return worksheetPart;
        }

        //insert cell in sheet based on column and row index            
        private Cell InsertCellInSheet(string columnName, uint rowIndex, WorksheetPart worksheetPart,Cell preCell)
        {
            Worksheet worksheet = worksheetPart.Worksheet;
            SheetData sheetData = worksheet.GetFirstChild<SheetData>();
            string cellReference = columnName + rowIndex;
            Row row;
            //check whether row exist or not            
            //if row exist            
            if (sheetData.Elements<Row>().Where(r => r.RowIndex == rowIndex).Count() != 0)
            {
                row = sheetData.Elements<Row>().Where(r => r.RowIndex == rowIndex).First();
            }
            //if row does not exist then it will create new row            
            else
            {
                row = new Row()
                {
                    RowIndex = rowIndex
                };
                sheetData.Append(row);
            }
            //check whether cell exist or not            
            //if cell exist            
            if (row.Elements<Cell>().Where(c => c.CellReference.Value == columnName + rowIndex).Count() > 0)
            {
                return row.Elements<Cell>().Where(c => c.CellReference.Value == cellReference).First();
            }
            //if cell does not exist            
            else if (preCell != null && preCell.CellReference != null)
            {
                Cell newCell = new Cell()
                {
                    CellReference = cellReference
                };
                row.InsertAfter(newCell, preCell);
                worksheet.Save();
                return newCell;
            }
            else 
            {
                Cell refCell = null;
                foreach (Cell cell in row.Elements<Cell>())
                {
                    if (string.Compare(cell.CellReference.Value, cellReference, true) > 0)
                    {
                        refCell = cell;
                        break;
                    }
                }
                Cell newCell = new Cell()
                {
                    CellReference = cellReference
                };
                row.InsertBefore(newCell, refCell);
                worksheet.Save();
                return newCell;
            }
        }
        private CloudBlobDirectory SetupCompanyFileContainer(CompanyOutputModel companyModel, int moduleTypeId, Guid loggedInUserId, string storageAccountName)
        {
            LoggingManager.Info("SetupCompanyFileContainer");

            CloudStorageAccount storageAccount = StorageAccount(storageAccountName);

            CloudBlobClient blobClient = storageAccount.CreateCloudBlobClient();

            Regex re = new Regex(@"(^{[&\/\\#,+()$~%._\'"":*?<>{}@`;^=-]})$");

            companyModel.CompanyName = companyModel.CompanyName.Replace(" ", string.Empty);

            re.Replace(companyModel.CompanyName, "");

            string company = (companyModel.CompanyId.ToString()).ToLower();

            CloudBlobContainer container = blobClient.GetContainerReference(company);

            try
            {
                bool isCreated = container.CreateIfNotExists();

                if (isCreated)
                {
                    container.SetPermissions(new BlobContainerPermissions
                    {
                        PublicAccess = BlobContainerPublicAccessType.Blob
                    });
                }
            }
            catch (StorageException e)
            {
                Console.WriteLine(e.Message);

                throw;
            }

            string directoryReference = moduleTypeId == (int)ModuleTypeEnum.Hrm ? AppConstants.HrmBlobDirectoryReference :
                 moduleTypeId == (int)ModuleTypeEnum.Assets ? AppConstants.AssetsBlobDirectoryReference :
                 moduleTypeId == (int)ModuleTypeEnum.FoodOrder ? AppConstants.FoodOrderBlobDirectoryReference :
                 moduleTypeId == (int)ModuleTypeEnum.Projects ? AppConstants.ProjectsBlobDirectoryReference :
                 moduleTypeId == (int)ModuleTypeEnum.Invoices ? AppConstants.ProjectsBlobDirectoryReference : AppConstants.LocalBlobContainerReference;

            CloudBlobDirectory moduleDirectory = container.GetDirectoryReference(directoryReference);

            CloudBlobDirectory userLevelDirectory = moduleDirectory.GetDirectoryReference(loggedInUserId.ToString());

            return userLevelDirectory;
        }
        private CloudStorageAccount StorageAccount(string storageAccountName)
        {
            LoggingManager.Debug("Entering into GetStorageAccount method of blob service");
            string account;
            if (string.IsNullOrEmpty(storageAccountName))
            {
                account = CloudConfigurationManager.GetSetting("StorageAccountName");
            }
            else
            {
                account = storageAccountName;
            }

            string key = CloudConfigurationManager.GetSetting("StorageAccountAccessKey");
            string connectionString = $"DefaultEndpointsProtocol=https;AccountName={account};AccountKey={key}";
            CloudStorageAccount storageAccount = CloudStorageAccount.Parse(connectionString);

            LoggingManager.Debug("Exit from GetStorageAccount method of blob service");

            return storageAccount;
        }
        private string RepalceFilterParams(string baseData, LoggedInContext loggedInContext, List<FilterKeyValuePair> filters)
        {

            if (baseData.Contains("@ProjectId"))
            {
                baseData.Replace("@ProjectId", filters.FirstOrDefault(x => x.IsSystemFilter == true && x.FilterKey == "Project" && !string.IsNullOrEmpty(x.FilterValue))?.FilterValue);
            }
            if (baseData.Contains("@UserId"))
            {
                baseData.Replace("@UserId", filters.FirstOrDefault(x => x.IsSystemFilter == true && x.FilterKey == "User" && !string.IsNullOrEmpty(x.FilterValue))?.FilterValue);
            }
            if (baseData.Contains("@EntityId"))
            {
                baseData.Replace("@EntityId", filters.FirstOrDefault(x => x.IsSystemFilter == true && x.FilterKey == "Entity" && !string.IsNullOrEmpty(x.FilterValue))?.FilterValue);
            }
            if (baseData.Contains("@DesignationId"))
            {
                baseData.Replace("@DesignationId", filters.FirstOrDefault(x => x.IsSystemFilter == true && x.FilterKey == "Designation" && !string.IsNullOrEmpty(x.FilterValue))?.FilterValue);
            }
            if (baseData.Contains("@BranchId"))
            {
                baseData.Replace("@BranchId", filters.FirstOrDefault(x => x.IsSystemFilter == true && x.FilterKey == "Branch" && !string.IsNullOrEmpty(x.FilterValue))?.FilterValue);
            }
            if (baseData.Contains("@RoleId"))
            {
                baseData.Replace("@RoleId", filters.FirstOrDefault(x => x.IsSystemFilter == true && x.FilterKey == "Role" && !string.IsNullOrEmpty(x.FilterValue))?.FilterValue);
            }
            if (baseData.Contains("@DepartmentId"))
            {
                baseData.Replace("@DepartmentId", filters.FirstOrDefault(x => x.IsSystemFilter == true && x.FilterKey == "Department" && !string.IsNullOrEmpty(x.FilterValue))?.FilterValue);
            }
            if (baseData.Contains("@IsFinancialYear"))
            {
                var IsFinancialYear = filters.FirstOrDefault(x => x.IsSystemFilter == true && x.FilterKey == "FinancialYear" && !string.IsNullOrEmpty(x.FilterValue))?.FilterValue;

                baseData.Replace("@IsFinancialYear", IsFinancialYear == "true" ? "1" : IsFinancialYear == "false" ? "0" : null);
            }
            if (baseData.Contains("@IsActiveEmployeesOnly"))
            {
                var ActiveEmployees = filters.FirstOrDefault(x => x.IsSystemFilter == true && x.FilterKey == "ActiveEmployees" && !string.IsNullOrEmpty(x.FilterValue))?.FilterValue;

                baseData.Replace("@IsActiveEmployeesOnly", ActiveEmployees == "true" ? "1" : ActiveEmployees == "false" ? "0" : null);
            }
            if (baseData.Contains("@Month"))
            {
                baseData.Replace("@Month", filters.FirstOrDefault(x => x.IsSystemFilter == true && x.FilterKey == "Month" && !string.IsNullOrEmpty(x.FilterValue))?.FilterValue);
            }
            if (baseData.Contains("@Year"))
            {
                baseData.Replace("@Year", filters.FirstOrDefault(x => x.IsSystemFilter == true && x.FilterKey == "Year" && !string.IsNullOrEmpty(x.FilterValue))?.FilterValue);
            }
            if (baseData.Contains("@OperationsPerformedBy"))
            {
                baseData.Replace("@OperationsPerformedBy", loggedInContext.LoggedInUserId.ToString());
            }
            if (baseData.Contains("@CompanyId"))
            {
                baseData.Replace("@CompanyId", loggedInContext.CompanyGuid.ToString());
            }
            if (baseData.Contains("@DateFrom") || baseData.Contains("@DateTo") || baseData.Contains("@Date"))
            {
                var dateValue = filters.FirstOrDefault(x => x.IsSystemFilter == true && x.FilterKey == "Date" && !string.IsNullOrEmpty(x.FilterValue))?.FilterValue;

                if (dateValue == "lastMonth" || dateValue == "thisMonth" || dateValue == "lastWeek" || dateValue == "nextWeek")
                {
                    DateFromDateTo(dateValue);
                }
                else if (!string.IsNullOrEmpty(dateValue))
                {
                    var obj = JsonConvert.DeserializeObject<DateFilterModel>(dateValue);
                    if (obj.Date != null && obj.DateFrom == null && obj.DateTo == null)
                    {
                        _date = obj.Date;
                    }
                    else
                    {
                        _dateFrom = obj.DateFrom;
                        _dateTo = obj.DateTo;
                    }
                }
                if (baseData.Contains("@DateFrom"))
                {
                    baseData.Replace("@DateFrom", _dateFrom != null ? _dateFrom.ToString() : null);
                }
                if (baseData.Contains("@DateTo"))
                {
                    baseData.Replace("@DateTo", _dateTo != null ? _dateTo.ToString() : null);
                }
                if (baseData.Contains("@Date"))
                {
                    baseData.Replace("@Date", _date != null ? _date.ToString() : null);
                }
            }

            return baseData;
        }

        private void DateFromDateTo(string filterName)
        {
            _dateFrom = new DateTime();
            _dateTo = new DateTime();
            DateTime now = DateTime.Today;
            if (filterName == "lastMonth")
            {
                var dFirstDayOfThisMonth = DateTime.Today.AddDays(-(DateTime.Today.Day - 1));
                _dateTo = dFirstDayOfThisMonth.AddDays(-1);
                _dateFrom = dFirstDayOfThisMonth.AddMonths(-1);
                //_dateFrom = new DateTime(now.Year, now.Month - 1, 1);
                //_dateTo = new DateTime(now.Year, now.Month, 1).AddDays(-1);
            }
            else if (filterName == "thisMonth")
            {
                var dFirstDayOfThisMonth = DateTime.Today.AddDays(-(DateTime.Today.Day - 1));
                _dateFrom = DateTime.Today.AddDays(-(DateTime.Today.Day - 1));
                _dateTo = dFirstDayOfThisMonth.AddMonths(1).AddDays(-1);

            }
            else if (filterName == "lastWeek")
            {
                _dateFrom = FirstDayOfWeek(now.AddDays(-7));
                _dateTo = LastDayOfWeek(now.AddDays(-7));
            }
            else if (filterName == "nextWeek")
            {
                _dateFrom = FirstDayOfWeek(now.AddDays(7));
                _dateTo = LastDayOfWeek(now.AddDays(7));
            }
        }

        private static DateTime FirstDayOfWeek(DateTime date)
        {
            DayOfWeek fdow = CultureInfo.CurrentCulture.DateTimeFormat.FirstDayOfWeek;
            int offset = fdow - date.DayOfWeek;
            DateTime fdowDate = date.AddDays(offset);
            return fdowDate.AddDays(1);
        }

        private static DateTime LastDayOfWeek(DateTime date)
        {
            DateTime ldowDate = FirstDayOfWeek(date).AddDays(6);
            return ldowDate;
        }

    }
}
