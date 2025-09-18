using System;
using System.Collections.Generic;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.BillingManagement;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using BTrak.Common;
using Btrak.Services.Helpers.BillingManagement;
using Btrak.Models.File;
using System.Web;
using DocumentFormat.OpenXml.Packaging;
using System.Linq;
using System.Data;
using System.Reflection;
using System.Web.Hosting;
using Btrak.Services.FileUpload;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Btrak.Services.Chromium;
using Btrak.Models.CompanyStructure;
using Btrak.Services.CompanyStructure;
using Btrak.Models.MasterData;
using Btrak.Dapper.Dal.Partial;
using Microsoft.WindowsAzure.Storage.Blob;
using Microsoft.Azure;
using Microsoft.WindowsAzure.Storage;
using static BTrak.Common.Enumerators;
using System.Text.RegularExpressions;
using Btrak.Services.Email;
using System.IO;
using Btrak.Models.SystemManagement;
using Newtonsoft.Json.Linq;
using System.Configuration;
using Btrak.Dapper.Dal.Models;
using Btrak.Models.TestRail;
using Btrak.Models.PayRoll;
using Btrak.Models.User;
using Btrak.Services.Notification;
using BTrak.Common.Constants;
using System.Net;
using Btrak.Models.Employee;
using GradeInputModel = Btrak.Models.BillingManagement.GradeInputModel;
using System.Globalization;
using Btrak.Models.HrManagement;
using Hangfire;
using System.Threading.Tasks;
using BusinessView.Common;
using JsonDeserialiseData = BTrak.Common.JsonDeserialiseData;

namespace Btrak.Services.BillingManagement
{
    public class ClientService : IClientService
    {
        private readonly ClientRepository _clientRepository;
        private readonly IAuditService _auditService;
        private readonly IFileService _fileService;
        private readonly GoalRepository _goalRepository;
        private readonly IChromiumService _chromiumService;
        private readonly ICompanyStructureService _companyStructureService;
        private readonly MasterDataManagementRepository _masterDataManagementRepository;
        private readonly IEmailService _emailService;
        private readonly INotificationService _notificationService;
        private readonly UserRepository _userRepository;
        private readonly PayRollRepository _payRollRepository;
        private readonly MasterDataManagementRepository _masterManagementRepository = new MasterDataManagementRepository();
        private readonly EmployeeContactDetailRepository _employeeContactDetailRepository;
        private readonly HtmlTemplateRepository _htmlTemplateRepository;
        private readonly CompanyStructureRepository _companyStructureRepository = new CompanyStructureRepository();

        public ClientService(ClientRepository clientRepository, INotificationService notificationService, IAuditService auditService,
            IFileService fileService, GoalRepository goalRepository,
            ChromiumService chromiumService, CompanyStructureService companyStructureService, EmployeeContactDetailRepository employeeContactDetailRepository,
            MasterDataManagementRepository masterDataManagementRepository, PayRollRepository payRollComponentRepository,
            IEmailService emailService, UserRepository userRepository, HtmlTemplateRepository templateRepository)
        {
            _clientRepository = clientRepository;
            _auditService = auditService;
            _fileService = fileService;
            _notificationService = notificationService;
            _goalRepository = goalRepository;
            _chromiumService = chromiumService;
            _companyStructureService = companyStructureService;
            _masterDataManagementRepository = masterDataManagementRepository;
            _emailService = emailService;
            _userRepository = userRepository;
            _payRollRepository = payRollComponentRepository;
            _employeeContactDetailRepository = employeeContactDetailRepository;
            _htmlTemplateRepository = templateRepository;

        }

        async public Task<Guid?> UpsertClient(UpsertClientInputModel upsertClientInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertClient", "Client Service"));

            LoggingManager.Debug(upsertClientInputModel.ToString());

            if (!ClientValidations.ValidateUpsertClient(upsertClientInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            //upsertClientInputModel.Password = upsertClientInputModel.FirstName + "." + upsertClientInputModel.LastName + "!";

            upsertClientInputModel.Password = "Test123!";

            //upsertClientInputModel.Password = Utilities.GetSaltedPassword(upsertClientInputModel.Password);
            var isClientIdNull = false;
            if (upsertClientInputModel.ClientId == null)
            {
                isClientIdNull = true;
            }

            UserInputModel userInputModel = new UserInputModel()
            {
                FirstName = upsertClientInputModel.FirstName,
                LastName = upsertClientInputModel.LastName,
                Password = upsertClientInputModel.Password,
                Email = upsertClientInputModel.Email,
                SurName = upsertClientInputModel.LastName,
                IsExternal = true,
                TimeZoneId = upsertClientInputModel.TimeZoneId,
                MobileNo = upsertClientInputModel.MobileNo,
                ProfileImage = upsertClientInputModel.ProfileImage,
                IsActive = upsertClientInputModel.IsVerified==true? upsertClientInputModel.IsVerified : upsertClientInputModel.IsActive,
                IsArchived = upsertClientInputModel.IsArchived,
                RoleId = upsertClientInputModel.RoleIds,
                IsFromClient = true
            };
            if (upsertClientInputModel.ClientId != null && upsertClientInputModel.ClientId != Guid.Empty)
            {
                userInputModel.UserId = _userRepository.GetUserAuthenticationIdByClientId(upsertClientInputModel.ClientId, loggedInContext, validationMessages);
            }

            var result = ApiWrapper.PutentityToApi(RouteConstants.ASUpsertUser, ConfigurationManager.AppSettings["AuthenticationServiceBasePath"], userInputModel, loggedInContext.AccessToken).Result;
            var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(result);
            var id = JsonConvert.SerializeObject(responseJson.Data);
            var responseid = (id != null && id != "null") ? id : null;
            if (responseJson.Success && responseid != null)
            {
                upsertClientInputModel.Password = Utilities.GetSaltedPassword(upsertClientInputModel.Password);
                var idGuid = Convert.ToString(responseJson.Data);
                upsertClientInputModel.UserAuthenticationId = new Guid(idGuid);
                if (upsertClientInputModel.ClientId != null && upsertClientInputModel.ClientId != Guid.Empty)
                {
                    userInputModel.UserId = null;
                }
                upsertClientInputModel.ClientId = _clientRepository.UpsertClient(upsertClientInputModel, loggedInContext, validationMessages);


                if (upsertClientInputModel.ClientId != null && (upsertClientInputModel.IsForLeadSubmission == null || upsertClientInputModel.IsForLeadSubmission == false))
                {
                    upsertClientInputModel.ClientAddressId = _clientRepository.UpsertClientAddress(upsertClientInputModel, loggedInContext, validationMessages);
                }

                if (upsertClientInputModel.IsKycSybmissionMailSent == true && isClientIdNull == true && validationMessages.Count == 0)
                {
                    var client = await SendEmailForKycSubmission(upsertClientInputModel, loggedInContext, validationMessages);
                }

                if (upsertClientInputModel.IsVerified == true && validationMessages.Count == 0)
                {

                    TaskWrapper.ExecuteFunctionInNewThread(() =>
                    {
                        BackgroundJob.Enqueue(() => SendClientRegistrationMail(upsertClientInputModel.ClientId, loggedInContext, validationMessages));
                    });
                }

                _auditService.SaveAudit(AppCommandConstants.UpsertClientCommandId, upsertClientInputModel, loggedInContext);

                LoggingManager.Debug(upsertClientInputModel.ClientId?.ToString());

                return upsertClientInputModel.ClientId;
            }
            else
            {
                if (responseJson?.ApiResponseMessages.Count > 0)
                {
                    var validationMessage = new ValidationMessage()
                    {
                        ValidationMessaage = responseJson.ApiResponseMessages[0].Message,
                        ValidationMessageType = MessageTypeEnum.Error,
                        Field = responseJson.ApiResponseMessages[0].FieldName
                    };
                    validationMessages.Add(validationMessage);
                }
                return null;
            }
        }
        async public Task<Guid?> ReSendKycEmail(UpsertClientInputModel upsertClientInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ReSendKycEmail", "Client Service"));

            LoggingManager.Debug(upsertClientInputModel.ToString());
            ClientInputModel clientInputModel = new ClientInputModel();
            clientInputModel.ClientId = upsertClientInputModel.ClientId;
            List<ClientOutputModel> clientList = _clientRepository.GetClients(clientInputModel, loggedInContext, validationMessages);
            if (clientList.Count > 0)
            {
                upsertClientInputModel.FirstName = clientList[0].FirstName;
                upsertClientInputModel.LastName = clientList[0].LastName;
                upsertClientInputModel.AddressLine1 = clientList[0].AddressLine1;
                upsertClientInputModel.AddressLine2 = clientList[0].AddressLine2;
                upsertClientInputModel.BusinessEmail = clientList[0].BusinessEmail;
                upsertClientInputModel.CompanyName = clientList[0].CompanyName;
                upsertClientInputModel.BusinessNumber = clientList[0].BusinessNumber;
                upsertClientInputModel.Email = clientList[0].Email;
                upsertClientInputModel.CompanyWebsite = clientList[0].CompanyWebsite;
                upsertClientInputModel.GstNumber = clientList[0].GstNumber;
                upsertClientInputModel.MobileNo = clientList[0].MobileNo;
                upsertClientInputModel.Zipcode = clientList[0].Zipcode;
                var client = await SendEmailForKycSubmission(upsertClientInputModel, loggedInContext, validationMessages);
                Guid? ClientId = _clientRepository.UpsertClientKycDetails(upsertClientInputModel, loggedInContext, validationMessages);
            }
            return upsertClientInputModel.ClientId;
        }

        public Guid? UpdateClientContractTemplates(UpsertClientInputModel upsertClientInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateClientContractTemplates", "Client Service"));

            LoggingManager.Debug(upsertClientInputModel.ToString());

            upsertClientInputModel.ClientId = _clientRepository.UpdateClientTemplates(upsertClientInputModel, loggedInContext, validationMessages);
            return upsertClientInputModel.ClientId;

        }
        public virtual List<ClientOutputModel> GetClients(ClientInputModel clientInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllClients", "Client Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllClients", "Client Service"));

            List<ClientOutputModel> clientList = _clientRepository.GetClients(clientInputModel, loggedInContext, validationMessages);

            if (clientInputModel.ClientId != null && (clientList[0].LeadSubmissions != null || clientList[0].ContractSubmissionsDetails != null))
            {
                if (clientList[0].ClientTypeName == "Suppilers")
                {
                    clientList[0].ContractSubmissionsDetails = JsonConvert.DeserializeObject<List<ContractSubmissionDetails>>(clientList[0].ContractSubmissions);
                }
                else
                {
                    clientList[0].LeadSubmissionsDetails = JsonConvert.DeserializeObject<List<LeadSubmissionsDetails>>(clientList[0].LeadSubmissions);
                }
            }

            clientList.ForEach(x => x.RoleId = (x.RoleIds != "" && x.RoleIds != null) ? x.RoleIds.Split(',').Select(Guid.Parse).ToList() : null);
            clientList.ForEach(x => x.ContractTemplateId = (x.ContractTemplateIds != "" && x.ContractTemplateIds != null) ? x.ContractTemplateIds.Split(',').Select(Guid.Parse).ToList() : null);
            clientList.ForEach(x => x.TradeTemplateId = (x.TradeTemplateIds != "" && x.TradeTemplateIds != null) ? x.TradeTemplateIds.Split(',').Select(Guid.Parse).ToList() : null);

            _auditService.SaveAudit(AppCommandConstants.GetClientsCommandId, clientInputModel, loggedInContext);

            return clientList;
        }

        public Guid? UpsertSCOStatus(LeadSubmissionsDetails clientInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertSCOStatus", "Client Service"));

            Guid? clientSubmissionId = _clientRepository.UpsertSCOStatus(clientInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.GetClientsCommandId, clientInputModel, loggedInContext);

            loggedInContext.CompanyGuid = clientInputModel.CompanyId;
            loggedInContext.LoggedInUserId = clientInputModel.UserId;

            SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, null);

            CompanySettingsSearchInputModel companySettingsSearchInputModel = new CompanySettingsSearchInputModel
            {
                Key = "SCOMail",
                IsArchived = false
            };

            var CompanyEmail = _masterManagementRepository.GetCompanySettings(companySettingsSearchInputModel, loggedInContext, null).Select(x => x.Value).FirstOrDefault();
            //CompanyEmail = "raghavendra.gududhuru@kothapalli.co.uk";
            if (clientSubmissionId != null)
            {
                string[] toEmails = { CompanyEmail, clientInputModel.Email };

                foreach (var email in toEmails)
                {
                    var sco = "SCO generated on " + Convert.ToDateTime(clientInputModel.CreatedDateTime.ToString()).ToString("dd-MMM-yyyy").ToString();

                    var pdfHtml = _goalRepository.GetHtmlTemplateByName("SCO Accept/Reject Mail", clientInputModel.CompanyId)
                                                 .Replace("##SCOCOMMENTS##", clientInputModel.Comments != null ? clientInputModel.Comments : "");

                    if (email == CompanyEmail)
                    {
                        pdfHtml = pdfHtml.Replace("Dear ##ToName##,", "Hello");
                    }
                    else
                    {
                        pdfHtml = pdfHtml.Replace("##ToName##", clientInputModel.FullName);
                    }

                    if (clientInputModel.IsScoAccepted == true)
                    {
                        if (email == CompanyEmail)
                        {
                            sco += " is accepted by " + clientInputModel.CompanyName;
                            pdfHtml = pdfHtml.Replace("##SCOMESSAGE##", sco);
                        }
                        else
                        {
                            sco += " is accepted by you";
                            pdfHtml = pdfHtml.Replace("##SCOMESSAGE##", sco);
                        }
                    }
                    if (clientInputModel.IsScoAccepted == false)
                    {
                        if (email == CompanyEmail)
                        {
                            sco += " is rejected by " + clientInputModel.CompanyName;
                            pdfHtml = pdfHtml.Replace("##SCOMESSAGE##", sco);
                        }
                        else
                        {
                            sco += " is rejected by you";
                            pdfHtml = pdfHtml.Replace("##SCOMESSAGE##", sco);
                        }
                    }

                    var toEmail = email.Trim().Split('\n');
                    TaskWrapper.ExecuteFunctionInNewThread(() =>
                    {
                        EmailGenericModel emailModel = new EmailGenericModel
                        {
                            SmtpServer = smtpDetails?.SmtpServer,
                            SmtpServerPort = smtpDetails?.SmtpServerPort,
                            SmtpMail = smtpDetails?.SmtpMail,
                            SmtpPassword = smtpDetails?.SmtpPassword,
                            ToAddresses = toEmail,
                            HtmlContent = pdfHtml,
                            Subject = "SCO Mail",
                            //CCMails = ccEmails,
                            //BCCMails = bccEmails,
                            MailAttachments = null
                        };
                        _emailService.SendMail(loggedInContext, emailModel);
                    });
                }
            }

            return clientSubmissionId;
        }

        public Guid? UpsertClientSecondaryContact(UpsertClientSecondaryContactModel upsertClientSecondaryContactModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertClientSecondaryContact", "Client Service"));

            LoggingManager.Debug(upsertClientSecondaryContactModel.ToString());

            if (!ClientValidations.ValidateUpsertClientSecondaryContact(upsertClientSecondaryContactModel, loggedInContext, validationMessages))
            {
                return null;
            }

            //upsertClientSecondaryContactModel.Password = upsertClientSecondaryContactModel.FirstName + "." + upsertClientSecondaryContactModel.LastName + "!";

            upsertClientSecondaryContactModel.Password = "Test123!";

            upsertClientSecondaryContactModel.Password = Utilities.GetSaltedPassword(upsertClientSecondaryContactModel.Password);

            upsertClientSecondaryContactModel.ClientSecondaryContactId = _clientRepository.UpsertClientSecondaryContact(upsertClientSecondaryContactModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertClientSecondaryContactCommandId, upsertClientSecondaryContactModel, loggedInContext);

            LoggingManager.Debug(upsertClientSecondaryContactModel.ClientSecondaryContactId?.ToString());

            return upsertClientSecondaryContactModel.ClientSecondaryContactId;
        }

        public List<ClientSecondaryContactOutputModel> GetClientSecondaryContacts(ClientSecondaryContactsInputModel clientSecondaryContactsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllClientSecondaryContacts", "Client Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllClientSecondaryContacts", "Client Service"));

            List<ClientSecondaryContactOutputModel> clientSecondaryContactList = _clientRepository.GetClientSecondaryContacts(clientSecondaryContactsInputModel, loggedInContext, validationMessages);

            clientSecondaryContactList.ForEach(x => x.RoleId = x.RoleIds.Split(',').Select(Guid.Parse).ToList());

            _auditService.SaveAudit(AppCommandConstants.GetClientSecondaryContactsCommandId, clientSecondaryContactsInputModel, loggedInContext);

            return clientSecondaryContactList;
        }

        public List<Guid?> MultipleClientDelete(MultipleClientDeleteModel multipleClientDeleteModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetClients", "ClientInputModel", multipleClientDeleteModel, "Client Service"));

            if (multipleClientDeleteModel.ClientId != null)
            {
                multipleClientDeleteModel.ClientIdXml = Utilities.ConvertIntoListXml(multipleClientDeleteModel.ClientId.ToArray());
            }

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.MultipleClientDeleteId, multipleClientDeleteModel, loggedInContext);

            List<Guid?> clientId = _clientRepository.MultipleClientDelete(multipleClientDeleteModel, loggedInContext, validationMessages);

            return clientId;
        }

        public List<ClientHistoryModel> GetClientHistory(ClientHistoryModel clientHistoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetClientHistory", "Client Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetClientHistory", "Client Service"));

            List<ClientHistoryModel> clientHistory = _clientRepository.GetClientHistory(clientHistoryModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.GetClientHistoryCommandId, clientHistoryModel, loggedInContext);

            return clientHistory;
        }

        public Guid? UpsertClientProjects(UpsertClientProjectsModel upsertClientProjectsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertClientProjects", "Client Service"));

            LoggingManager.Debug(upsertClientProjectsModel.ToString());

            if (!ClientValidations.ValidateUpsertClientProjects(upsertClientProjectsModel, loggedInContext, validationMessages))
            {
                return null;
            }

            upsertClientProjectsModel.ClientProjectId = _clientRepository.UpsertClientProjects(upsertClientProjectsModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertClientProjectsCommandId, upsertClientProjectsModel, loggedInContext);

            LoggingManager.Debug(upsertClientProjectsModel.ClientId?.ToString());

            return upsertClientProjectsModel.ClientProjectId;
        }

        public List<ClientProjectsOutputModel> GetClientProjects(ClientProjectsInputModel clientProjectsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetClientProjects", "Client Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetClientProjects", "Client Service"));

            List<ClientProjectsOutputModel> clientProjects = _clientRepository.GetClientProjects(clientProjectsInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.GetClientProjectsCommandId, clientProjectsInputModel, loggedInContext);

            return clientProjects;
        }

        public Task<List<FileResult>> ExportClient(HttpRequest httpRequest, ClientInputModel clientInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllClients", "Client Service"));

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllClients", "Client Service"));
            List<ClientOutputModel> clientList = _clientRepository.GetClients(clientInputModel, loggedInContext, validationMessages);
            if (clientList.Count > 0)
            {
                DataTable clientDataTable = ConvertListToDatatable(clientList);
                DataSet clientDataSet = new DataSet();
                clientDataSet.Tables.Add(clientDataTable);
                var path = HostingEnvironment.MapPath(@"~/ExcelTemplates/ClientExport.xlsx");
                var returnedValue = ExportDataSet(httpRequest, clientDataSet, path, loggedInContext);
                return returnedValue;
            }
            return null;
        }
        public Task<List<FileResult>> ImportClient(HttpRequest httpRequest, ClientInputModel clientInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllClients", "Client Service"));

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllClients", "Client Service"));
            List<ClientOutputModel> clientList = new List<ClientOutputModel>();
            DataTable clientDataTable = ConvertListToDatatable(clientList);
            DataSet clientDataSet = new DataSet();
            clientDataSet.Tables.Add(clientDataTable);
            var path = HostingEnvironment.MapPath(@"~/ExcelTemplates/ClientExport.xlsx");
            var returnedValue = ExportDataSet(httpRequest, clientDataSet, path, loggedInContext);
            return returnedValue;
        }

        public static DataTable ConvertListToDatatable(List<ClientOutputModel> clientOutputModel)
        {
            DataTable dataTable = new DataTable(typeof(ClientOutputModel).Name);
            PropertyInfo[] props = typeof(ClientOutputModel).GetProperties(BindingFlags.Public | BindingFlags.Instance);
            foreach (PropertyInfo prop in props)
            {
                var type = (prop.PropertyType.IsGenericType && prop.PropertyType.GetGenericTypeDefinition() == typeof(Nullable<>) ? Nullable.GetUnderlyingType(prop.PropertyType) : prop.PropertyType);
                dataTable.Columns.Add(prop.Name, type);
            }
            foreach (ClientOutputModel item in clientOutputModel)
            {
                var values = new object[props.Length];
                for (int i = 0; i < props.Length; i++)
                {
                    values[i] = props[i].GetValue(item, null);
                }
                dataTable.Rows.Add(values);
            }
            return dataTable;
        }

        public Task<List<FileResult>> ExportDataSet(HttpRequest httpRequest, DataSet ds, string destination, LoggedInContext loggedInContext)
        {
            using (var workbook = SpreadsheetDocument.Open(destination, true))
            {
                workbook.WorkbookPart.Workbook = new DocumentFormat.OpenXml.Spreadsheet.Workbook
                {
                    Sheets = new DocumentFormat.OpenXml.Spreadsheet.Sheets()
                };

                foreach (DataTable table in ds.Tables)
                {
                    var sheetPart = workbook.WorkbookPart.AddNewPart<WorksheetPart>();
                    var sheetData = new DocumentFormat.OpenXml.Spreadsheet.SheetData();
                    sheetPart.Worksheet = new DocumentFormat.OpenXml.Spreadsheet.Worksheet(sheetData);
                    DocumentFormat.OpenXml.Spreadsheet.Sheets sheets = workbook.WorkbookPart.Workbook.GetFirstChild<DocumentFormat.OpenXml.Spreadsheet.Sheets>();
                    string relationshipId = workbook.WorkbookPart.GetIdOfPart(sheetPart);
                    uint sheetId = 1;
                    if (sheets.Elements<DocumentFormat.OpenXml.Spreadsheet.Sheet>().Count() > 0)
                    {
                        sheetId =
                            sheets.Elements<DocumentFormat.OpenXml.Spreadsheet.Sheet>().Select(s => s.SheetId.Value).Max() + 1;
                    }
                    DocumentFormat.OpenXml.Spreadsheet.Sheet sheet = new DocumentFormat.OpenXml.Spreadsheet.Sheet() { Id = relationshipId, SheetId = sheetId, Name = table.TableName };
                    sheets.Append(sheet);
                    DocumentFormat.OpenXml.Spreadsheet.Row headerRow = new DocumentFormat.OpenXml.Spreadsheet.Row();
                    List<String> columns = new List<string>();
                    foreach (System.Data.DataColumn column in table.Columns)
                    {
                        columns.Add(column.ColumnName);
                        DocumentFormat.OpenXml.Spreadsheet.Cell cell = new DocumentFormat.OpenXml.Spreadsheet.Cell();
                        cell.DataType = DocumentFormat.OpenXml.Spreadsheet.CellValues.String;
                        cell.CellValue = new DocumentFormat.OpenXml.Spreadsheet.CellValue(column.ColumnName);
                        headerRow.AppendChild(cell);
                    }
                    sheetData.AppendChild(headerRow);
                    foreach (System.Data.DataRow dsrow in table.Rows)
                    {
                        DocumentFormat.OpenXml.Spreadsheet.Row newRow = new DocumentFormat.OpenXml.Spreadsheet.Row();
                        foreach (String col in columns)
                        {
                            DocumentFormat.OpenXml.Spreadsheet.Cell cell = new DocumentFormat.OpenXml.Spreadsheet.Cell();
                            cell.DataType = DocumentFormat.OpenXml.Spreadsheet.CellValues.String;
                            cell.CellValue = new DocumentFormat.OpenXml.Spreadsheet.CellValue(dsrow[col].ToString()); //
                            newRow.AppendChild(cell);
                        }
                        sheetData.AppendChild(newRow);
                    }
                }
                workbook.Close();
                var validationMessages = new List<ValidationMessage>();
                httpRequest.SaveAs(destination, true);
                var returnedValue = _fileService.UploadFile(httpRequest, loggedInContext, validationMessages, 1);
                return returnedValue;
            }
        }
        public Guid? UpsertClientKycConfiguration(ClientKycConfiguration kycConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertClientKycConfiguration", "kycConfiguration", kycConfiguration, "Performance Service"));

            Guid? PerformanceId = null;

            if (kycConfiguration.ClientTypeId == null && kycConfiguration.IsFromApp != true)
            {
                PerformanceId = _clientRepository.UpsertClientKycForm(kycConfiguration, loggedInContext, validationMessages);
            }
            else
            {
                if (kycConfiguration.SelectedRoleIds.Count > 0)
                {
                    kycConfiguration.SelectedRoles = String.Join(",", kycConfiguration.SelectedRoleIds);
                }
                //if (kycConfiguration.selectedLegalEntityIds.Count > 0)
                //{
                //    kycConfiguration.SelectedLegalEntites = String.Join(",", kycConfiguration.selectedLegalEntityIds);
                //}
                PerformanceId = _clientRepository.UpsertClientKycConfiguration(kycConfiguration, loggedInContext, validationMessages);
            }
            if (validationMessages.Count == 0)
            {
                _auditService.SaveAudit(AppConstants.Performance, kycConfiguration, loggedInContext);
                return PerformanceId;
            }

            return null;
        }
        public List<ClientKycConfigurationOutputModel> GetClientKycConfiguration(ClientKycConfiguration clientkycConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetPerformanceConfigurations", "PerformanceConfigurationModel", clientkycConfiguration, "Performance Service"));

            List<ClientKycConfigurationOutputModel> PerformanceConfigurations = _clientRepository.GetClientKycConfiguration(clientkycConfiguration, loggedInContext, validationMessages);

            Parallel.ForEach(PerformanceConfigurations, performance =>
            {
                if (!string.IsNullOrEmpty(performance.SelectedRoles))
                {
                    performance.SelectedRoleIds = performance.SelectedRoles.Split(',').ToList().ConvertAll(Guid.Parse);
                }
            });

            //Parallel.ForEach(PerformanceConfigurations, performance =>
            //{
            //    if (!string.IsNullOrEmpty(performance.SelectedLegalEntities))
            //    {
            //        performance.SelectedLegalEntityIds = performance.SelectedLegalEntities.Split(',').ToList().ConvertAll(Guid.Parse);
            //    }
            //});
            if (validationMessages.Count == 0)
            {
                _auditService.SaveAudit(AppConstants.Performance, clientkycConfiguration, loggedInContext);
                return PerformanceConfigurations;
            }

            return null;
        }

        public Guid? UpsertPurchaseConfiguration(PurchaseConfigInputModel kycConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertClientKycConfiguration", "kycConfiguration", kycConfiguration, "Performance Service"));


            Guid? PerformanceId = null;

            if (kycConfiguration.SelectedRoleIds.Count > 0)
            {
                kycConfiguration.SelectedRoles = String.Join(",", kycConfiguration.SelectedRoleIds);
            }
            PerformanceId = _clientRepository.UpsertPurchaseConfiguration(kycConfiguration, loggedInContext, validationMessages);

            if (validationMessages.Count == 0)
            {
                _auditService.SaveAudit(AppConstants.Performance, kycConfiguration, loggedInContext);
                return PerformanceId;
            }

            return null;
        }
        public List<PurchaseConfigOutputModel> GetPurchaseConfiguration(PurchaseConfigInputModel clientkycConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetPerformanceConfigurations", "PerformanceConfigurationModel", clientkycConfiguration, "Performance Service"));

            List<PurchaseConfigOutputModel> PerformanceConfigurations = _clientRepository.GetPurchaseConfiguration(clientkycConfiguration, loggedInContext, validationMessages);

            Parallel.ForEach(PerformanceConfigurations, performance =>
            {
                if (!string.IsNullOrEmpty(performance.SelectedRoles))
                {
                    performance.SelectedRoleIds = performance.SelectedRoles.Split(',').ToList().ConvertAll(Guid.Parse);
                }
            });

            if (validationMessages.Count == 0)
            {
                _auditService.SaveAudit(AppConstants.Performance, clientkycConfiguration, loggedInContext);
                return PerformanceConfigurations;
            }

            return null;
        }

        public List<ClientTypeOutputModel> GetClientTypes(ClientInputModel clientInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetClientTypes", "Client Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetClientTypes", "Client Service"));

            List<ClientTypeOutputModel> clientTypeList = _clientRepository.GetClientTypes(clientInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.GetClientsCommandId, clientInputModel, loggedInContext);

            return clientTypeList;
        }
        public List<ClientTypeOutputModel> GetClientTypesBasedOnRoles(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetClientTypesBasedOnRoles", "Client Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetClientTypesBasedOnRoles", "Client Service"));

            List<ClientTypeOutputModel> clientTypeList = _clientRepository.GetClientTypesBasedOnRoles(loggedInContext, validationMessages);

            return clientTypeList;
        }
        public Guid? UpsertClientType(ClientTypeUpsertInputModel clientTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertClientType", "Client Service", clientTypeUpsertInputModel, "Performance Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            clientTypeUpsertInputModel.ClientTypeId = _clientRepository.UpsertClientType(clientTypeUpsertInputModel, loggedInContext, validationMessages);

                _auditService.SaveAudit(AppCommandConstants.UpsertClientTypeCommandId, clientTypeUpsertInputModel, loggedInContext);
            return clientTypeUpsertInputModel.ClientTypeId;
        }
        public Guid? ReOrderClientType(ClientTypeUpsertInputModel clientTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "clientTypeUpsertInputModel", "Client Service"));

            if (clientTypeUpsertInputModel.clientTypeIds != null && clientTypeUpsertInputModel.clientTypeIds.Count > 0)
            {
                clientTypeUpsertInputModel.clientTypeIdsXml = Utilities.ConvertIntoListXml(clientTypeUpsertInputModel.clientTypeIds);
            }
            else
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyFromWorkFlowUserStoryStatusId
                });
                return null;
            }

            _clientRepository.ReOrderClientTypes(clientTypeUpsertInputModel, loggedInContext, validationMessages);

            return null;
        }
        public List<ShipToAddressSearchOutputModel> GetShipToAddresses(ShipToAddressSearchInputModel shipToAddressSearchInputModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetShipToAddresses", "Client Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetShipToAddresses", "Client Service"));

            List<ShipToAddressSearchOutputModel> shipToAddresses = _clientRepository.GetShipToAddresses(shipToAddressSearchInputModel,loggedInContext, validationMessages);

            return shipToAddresses;
        }
        public Guid? UpsertShipToAddress(ShipToAddressUpsertInputModel shipToAddressUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertShipToAddress", "Client Service", shipToAddressUpsertInputModel, "Performance Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            shipToAddressUpsertInputModel.AddressId = _clientRepository.UpsertShipToAddress(shipToAddressUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertClientTypeCommandId, shipToAddressUpsertInputModel, loggedInContext);
            return shipToAddressUpsertInputModel.AddressId;
        }

        public List<ContractSubmissionDetails> GetContractSubmissions(ContractSubmissionDetails clientInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ContractSubmissionDetails", "Client Service"));

            List<ContractSubmissionDetails> clientSubmissionList = _clientRepository.GetContractSubmissions(clientInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.GetClientsCommandId, clientInputModel, loggedInContext);

            return clientSubmissionList;
        }

        public List<MasterContractOutputModel> GetMasterContractDetails(MasterContractInputModel clientInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ContractSubmissionDetails", "Client Service"));

            List<MasterContractOutputModel> clientSubmissionList = _clientRepository.GetMasterContractDetails(clientInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.GetClientsCommandId, clientInputModel, loggedInContext);

            return clientSubmissionList;
        }

        public List<SCOGenerationsOutputModel> GetSCOGenerations(SCOGenerationSerachInputModel sCOGenerationSerachInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSCOGenerations", "Client Service"));

            List<SCOGenerationsOutputModel> sCOGenerations = _clientRepository.GetSCOGenerations(sCOGenerationSerachInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.GetSCosCommandId, sCOGenerationSerachInputModel, loggedInContext);

            return sCOGenerations;
        }

        public List<SCOGenerationsOutputModel> GetScoGenerationById(SCOGenerationSerachInputModel sCOGenerationSerachInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSCOGenerations", "Client Service"));

            List<SCOGenerationsOutputModel> sCOGenerations = _clientRepository.GetScoGenerationById(sCOGenerationSerachInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.GetSCosCommandId, sCOGenerationSerachInputModel, loggedInContext);

            return sCOGenerations;
        }

        public Guid? UpsertSCOGeneration(SCOUpsertInputModel sCOUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertSCOGeneration", "Client Service"));

            LoggingManager.Debug(sCOUpsertInputModel.ToString());

            if (!ClientValidations.ValidateUpsertSCOGeneration(sCOUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            sCOUpsertInputModel.Id = _clientRepository.UpsertSCOGeneration(sCOUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertSCosCommandId, sCOUpsertInputModel, loggedInContext);

            LoggingManager.Debug(sCOUpsertInputModel.Id?.ToString());

            return sCOUpsertInputModel.Id;
        }

        public async Task<string> UpsertSCOMailToClient(UpsertClientInputModel invoiceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DownloadOrSendPdfInvoice", "Invoice Service"));
            {
                SCOUpsertInputModel sCOUpsertInputModel = new SCOUpsertInputModel();
                sCOUpsertInputModel.ClientId = invoiceInputModel.ClientId;
                sCOUpsertInputModel.LeadSubmissionId = invoiceInputModel.LeadFormId;
                sCOUpsertInputModel.IsArchived = false;
                sCOUpsertInputModel.CreditsAllocated = invoiceInputModel.CreditsAllocated;
                sCOUpsertInputModel.IsScoAccepted = null;
                sCOUpsertInputModel.IsForPdfs = false;
                var Id = _clientRepository.UpsertSCOGeneration(sCOUpsertInputModel, loggedInContext, validationMessages);
                List<ScoPdfColumnsGenerationModel> columnNames = new List<ScoPdfColumnsGenerationModel> {
                                    new ScoPdfColumnsGenerationModel { ColumnName="Contract Number", ColumnModelName="ContractNumber" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName="Unique Lead ID", ColumnModelName="UniqueLeadId" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName="Unique SCO ID", ColumnModelName="UniqueScoId" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName="SCO Date", ColumnModelName="ScoDate" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName="Sales Person Name", ColumnModelName="SalesPersonName" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName="Product", ColumnModelName="ProductName" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName="Grade", ColumnModelName="GradeName" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName="Buyer's Name", ColumnModelName="BuyerName" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName="GST Number", ColumnModelName="GstNumber" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName = "Ship To Address", ColumnModelName = "ShipToAddress" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName = "Vehicle Number of Transporter", ColumnModelName = "VehicleNumberOfTransporter" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName = "Mobile Number of Truck Driver", ColumnModelName = "MobileNumberOfTruckDriver" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName = "Quantity(MT)", ColumnModelName = "QuantityInMT" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName = "Drums", ColumnModelName = "Drums" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName = "Net Weight Approx", ColumnModelName = "NetApprox" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName = "Loading From", ColumnModelName = "PortName" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName = "Mode/Terms of payment", ColumnModelName = "PaymentTermName" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName = "Rate + GST", ColumnModelName = "RateGst" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName = "BL Number", ColumnModelName = "BLNumber" } };

                string scoPdfView = string.Empty;
                SCOGenerationSerachInputModel sCOGenerationSerachInputModel = new SCOGenerationSerachInputModel();
                sCOGenerationSerachInputModel.Id = Id;
                List<SCOGenerationsOutputModel> sCOGenerations = _clientRepository.GetSCOGenerations(sCOGenerationSerachInputModel, loggedInContext, validationMessages);
                sCOGenerations[0].NetApprox = sCOGenerations[0].QuantityInMT / sCOGenerations[0].Drums;
                var xx = sCOGenerations[0].GstNumber;
                var typeOfClass = typeof(SCOGenerationsOutputModel);
                PropertyInfo dataProp;
                object data;
                var table = "<table style=\"width: 100%; border-collapse: collapse;\"><tr>";
                table += "<th class=\"form-v-table\"style=\"background-color:#cececa\">Fields</th><th class=\"form-v-table\"style=\"background-color:#cececa\">Value</th></tr>";
                foreach (var columnName in columnNames)
                {
                    dataProp = typeOfClass.GetProperty(columnName.ColumnModelName);
                    data = dataProp.GetValue(sCOGenerations[0]);
                    //scoPdfView += "<p>" + columnName.ColumnName + "   :   " + data + "</p>";
                    table += "<tr><td class=\"form-v-table\">" + columnName.ColumnName + "</td>";
                    
                    if(columnName.ColumnModelName == "QuantityInMT")
                    {
                        if (data.ToString().Split('.')[0].Length <= 1)
                        {
                            data = sCOGenerations[0].QuantityInMT.ToString("0.00");
                        }
                        else
                        {
                            data = string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", sCOGenerations[0].QuantityInMT);
                        }
                    }
                    if(columnName.ColumnModelName == "NetApprox")
                    {
                        if (data.ToString().Split('.')[0].Length <= 1)
                        {
                            data = sCOGenerations[0].NetApprox.ToString("0.00");
                        }
                        else
                        {
                            data = string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", sCOGenerations[0].NetApprox);
                        }
                    }
                    if(columnName.ColumnModelName == "RateGst")
                    {
                        if (data.ToString().Split('.')[0].Length <= 1)
                        {
                            data = sCOGenerations[0].RateGst.ToString("0.00");
                        }
                        else
                        {
                            data = string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", sCOGenerations[0].RateGst);
                        }
                    }
                    if (columnName.ColumnModelName == "ScoDate")
                    {
                        data = Convert.ToDateTime(sCOGenerations[0].ScoDate.ToString()).ToString("dd-MM-yyyy").ToString();
                    }
                    table += "<td class=\"form-v-table\">" + data + "</td>";
                    table += "</tr>";
                }
                table += "</table>";

                CompanyThemeModel companyTheme = _companyStructureService.GetCompanyTheme(loggedInContext?.LoggedInUserId);
                var CompanyLogo = companyTheme.CompanyMainLogo != null ? companyTheme.CompanyMainLogo : "http://todaywalkins.com/Comp_images/Snovasys.png";

                var html = _goalRepository.GetHtmlTemplateByName("SCO Template", loggedInContext.CompanyGuid).Replace("##invoicePDFJson##", table).Replace("##CompanyLogo##", CompanyLogo);

                EmployeeCreditorDetailsSearchInputModel employeeCreditorDetailsSearchInputModel = new EmployeeCreditorDetailsSearchInputModel();

                employeeCreditorDetailsSearchInputModel.UseForPerformaInvoice = true;



                List<EmployeeCreditorDetailsSearchOutputModel> EmployeeCreditorDetails = _payRollRepository.GetEmployeeCreditorDetails(employeeCreditorDetailsSearchInputModel, loggedInContext, validationMessages).ToList();

                var performa2Html = _goalRepository.GetHtmlTemplateByName("Performa Invoice", loggedInContext.CompanyGuid);


                var performaHtml = _goalRepository.GetHtmlTemplateByName("Performa Invoice", loggedInContext.CompanyGuid).Replace("##Date##", Convert.ToDateTime(sCOGenerations[0].CreatedDateTime.ToString()).ToString("dd-MMM-yyyy").ToString())
                                                                               .Replace("##PaymentTerms##", sCOGenerations[0].PaymentTermName)
                                                                               .Replace("##TermsofDelivery##", sCOGenerations[0].TermsOfDelivery)
                                                                               .Replace("##CountryOfOrigin##", sCOGenerations[0].CountryOfOrigin)
                                                                               .Replace("##Shipment##", sCOGenerations[0].ShipmentMonth != null ? Convert.ToDateTime(sCOGenerations[0].ShipmentMonth.ToString()).ToString("MMMM-yyyy").ToString() : null)
                                                                               .Replace("##POD##", sCOGenerations[0].PortName)
                                                                               .Replace("##CustomPoint##", sCOGenerations[0].CustomPoint)
                                                                               .Replace("##ProductName##", sCOGenerations[0].ProductName)
                                                                               .Replace("##GstCode##", sCOGenerations[0].GstCode)
                                                                               .Replace("##Quantity##", sCOGenerations[0].QuantityInMT.ToString())
                                                                               .Replace("##Rate##", sCOGenerations[0].RateGst.ToString())
                                                                               .Replace("##TotalAmount##", Convert.ToDouble(sCOGenerations[0].QuantityInMT * sCOGenerations[0].RateGst).ToString("N0"))
                                                                               .Replace("##TotalAmountInWords##", "INR " + NumberToWords((int)Math.Round(sCOGenerations[0].QuantityInMT * sCOGenerations[0].RateGst)) + " Only")
                                                                               .Replace("##CompanyLogo##", CompanyLogo)
                                                                               .Replace("##ShippingAddress##", sCOGenerations[0].ShipToAddress)
                                                                               .Replace("##CompanyPan##", EmployeeCreditorDetails.Count > 0 ? EmployeeCreditorDetails[0].PanNumber : null)
                                                                               .Replace("##BankName##", EmployeeCreditorDetails.Count > 0 ? EmployeeCreditorDetails[0].BankName : null)
                                                                               .Replace("##ACNO##", EmployeeCreditorDetails.Count > 0 ? EmployeeCreditorDetails[0].AccountNumber : null)
                                                                               .Replace("##Branch&IFSCode##", EmployeeCreditorDetails.Count > 0 ? EmployeeCreditorDetails[0].BranchName + " & " + EmployeeCreditorDetails[0].IfScCode : null)
                                                                               .Replace("##InvoiceNo##", sCOGenerations[0].InvoiceNumber != null ? sCOGenerations[0].InvoiceNumber.ToString() : null)
                                                                               .Replace("##DeliveryNote##", sCOGenerations[0].DeliveryNote != null ? sCOGenerations[0].DeliveryNote.ToString() : null)
                                                                               .Replace("##SupllierRef##", sCOGenerations[0].SuppliersRef != null ? sCOGenerations[0].SuppliersRef.ToString() : null)
                                                                               .Replace("##OtherRef##", sCOGenerations[0].Drums.ToString())
                                                                               .Replace("##LoadingFrom##", sCOGenerations[0].PortName)
                                                                               .Replace("##AddressLine1##", sCOGenerations[0].AddressLine1 != null ? sCOGenerations[0].AddressLine1.ToString() : null)
                                                                               .Replace("##AddressLine2##", sCOGenerations[0].AddressLine2 != null ? sCOGenerations[0].AddressLine2.ToString() : null)
                                                                               .Replace("##PanNumber##", sCOGenerations[0].PanNumber != null ? sCOGenerations[0].PanNumber.ToString() : null)
                                                                               .Replace("##BusinessEmail##", sCOGenerations[0].BusinessEmail != null ? sCOGenerations[0].BusinessEmail.ToString() : null)
                                                                               .Replace("##BusinessNumber##", sCOGenerations[0].BusinessNumber != null ? sCOGenerations[0].BusinessNumber.ToString() : null)
                                                                               .Replace("##EximCode##", sCOGenerations[0].EximCode != null ? sCOGenerations[0].EximCode.ToString() : null)
                                                                               ;

                var PerformaPdfOutput = await _chromiumService.GeneratePdf(performaHtml, null, invoiceInputModel.ClientId.ToString());


                var pdfOutput = await _chromiumService.GeneratePdf(html, null, invoiceInputModel.ClientId.ToString());


                CompanyOutputModel companyModel = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);



                var companySettingsSearchInputModel = new CompanySettingsSearchInputModel();
                companySettingsSearchInputModel.CompanyId = companyModel?.CompanyId;
                companySettingsSearchInputModel.IsSystemApp = null;
                string storageAccountName = string.Empty;

                List<CompanySettingsSearchOutputModel> companySettings = _masterDataManagementRepository.GetCompanySettings(companySettingsSearchInputModel, loggedInContext, validationMessages).ToList();
                if (companySettings.Count > 0)
                {
                    var storageAccountDetails = companySettings.Where(x => x.Key == "StorageAccountName").FirstOrDefault();
                    storageAccountName = storageAccountDetails?.Value;
                }

                var directory = SetupCompanyFileContainer(companyModel, 6, loggedInContext.LoggedInUserId, storageAccountName);

                var fileName = invoiceInputModel.ClientId.ToString();

                LoggingManager.Debug("UploadCourseFile input fileName:" + fileName);

                fileName = fileName.Replace(" ", "_");

                var fileExtension = ".pdf";

                var convertedFileName = fileName + "-" + Guid.NewGuid() + fileExtension;

                CloudBlockBlob blockBlob = directory.GetBlockBlobReference(convertedFileName);

                blockBlob.Properties.CacheControl = "public, max-age=2592000";

                blockBlob.Properties.ContentType = "application/pdf";

                Byte[] bytes = pdfOutput.ByteStream;

                blockBlob.UploadFromByteArray(bytes, 0, bytes.Length);

                var fileurl = blockBlob.Uri.AbsoluteUri;

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DownloadOrSendPdfInvoice", "Invoice Service"));

                LoggingManager.Debug(pdfOutput.ByteStream.ToString());

                Stream stream = new MemoryStream(pdfOutput.ByteStream);
                //SCO Generation END

                //PERFORMA INVOICE 

                var PerformFileName = "Performa invoice";

                var PerformConvertedFileName = PerformFileName + "-" + Guid.NewGuid() + fileExtension;

                CloudBlockBlob PerformaBlockBlob = directory.GetBlockBlobReference(PerformConvertedFileName);

                PerformaBlockBlob.Properties.CacheControl = "public, max-age=2592000";

                PerformaBlockBlob.Properties.ContentType = "application/pdf";

                Byte[] PerformaBytes = PerformaPdfOutput.ByteStream;

                PerformaBlockBlob.UploadFromByteArray(PerformaBytes, 0, PerformaBytes.Length);

                Stream PerformaStream = new MemoryStream(PerformaPdfOutput.ByteStream);

                var performaUrl = PerformaBlockBlob.Uri.AbsoluteUri;

                List<StreamWithType> fileStream = new List<StreamWithType>();
                fileStream.Add(new StreamWithType() { FileStream = stream, FileName = convertedFileName, FileType = ".pdf", IsPdf = true });
                fileStream.Add(new StreamWithType() { FileStream = PerformaStream, FileName = PerformConvertedFileName, FileType = ".pdf", IsPdf = true });

                var toEmails = invoiceInputModel.Email.Trim().Split('\n');
                var siteDomain = ConfigurationManager.AppSettings["SiteUrl"];
                var AcceptAddress = siteDomain + "/sco/scoAcceptOrReject/" + invoiceInputModel.LeadFormId + '/' + Id;

                var pdfHtml = _goalRepository.GetHtmlTemplateByName("SCO Mail", loggedInContext.CompanyGuid)
                                        .Replace("##ToName##", invoiceInputModel.FirstName)
                                        .Replace("##PdfUrl##", fileurl)
                                        .Replace("##ScoAddress##", AcceptAddress)
                                        .Replace("Shobha Exim Team", "##footerName##");

                string mobileNo = invoiceInputModel.CountryCode + invoiceInputModel.MobileNo;
                var messageBody = "You have successfully generated SCO, Open " + fileurl;
                var subject = "SCO from " + companyModel.CompanyName;
                SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, HttpContext.Current.Request.Url.Authority);
                TaskWrapper.ExecuteFunctionInNewThread(() =>
                    {
                        EmailGenericModel emailModel = new EmailGenericModel
                        {
                            SmtpServer = smtpDetails?.SmtpServer,
                            SmtpServerPort = smtpDetails?.SmtpServerPort,
                            SmtpMail = smtpDetails?.SmtpMail,
                            SmtpPassword = smtpDetails?.SmtpPassword,
                            ToAddresses = toEmails,
                            HtmlContent = pdfHtml,
                            Subject = subject,
                            //CCMails = ccEmails,
                            //BCCMails = bccEmails,
                            MailAttachments = null,
                            MailAttachmentsWithFileType = fileStream,
                            IsPdf = true
                        };
                        _emailService.SendMail(loggedInContext, emailModel);
                        _emailService.SendSMS(mobileNo, messageBody, loggedInContext);
                    });

                SCOUpsertInputModel sCOUpsert = new SCOUpsertInputModel();
                sCOUpsert.Id = Id;
                sCOUpsert.PerformaPdf = performaUrl;
                sCOUpsert.ScoPdf = fileurl;
                sCOUpsert.TimeStamp = sCOGenerations[0].TimeStamp;
                sCOUpsert.IsForPdfs = true;
                var UpdateId = _clientRepository.UpsertSCOGeneration(sCOUpsert, loggedInContext, validationMessages);

                return fileurl;
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

        public async Task<string> SendSCOAcceptanceMail(List<SendSCOAcceptanceMailInputModel> sendSCOAcceptanceMailInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SendSCOAcceptanceMail", "Client Service"));
            SCOGenerationSerachInputModel sCOGenerationSerachInputModel = new SCOGenerationSerachInputModel();
            sCOGenerationSerachInputModel.LeadSubmissionId = sendSCOAcceptanceMailInputModel[0].LeadId;
            List<SCOGenerationsOutputModel> sCOGenerations = _clientRepository.GetSCOGenerations(sCOGenerationSerachInputModel, loggedInContext, validationMessages);
            List<ScoPdfColumnsGenerationModel> columnNames = new List<ScoPdfColumnsGenerationModel> {
                                    new ScoPdfColumnsGenerationModel { ColumnName="Contract Number", ColumnModelName="ContractNumber" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName="Unique Lead ID", ColumnModelName="UniqueLeadId" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName="Unique SCO ID", ColumnModelName="UniqueScoId" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName="SCO Date", ColumnModelName="ScoDate" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName="Sales Person Name", ColumnModelName="SalesPersonName" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName="Product", ColumnModelName="ProductName" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName="Grade", ColumnModelName="GradeName" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName="Buyer's Name", ColumnModelName="BuyerName" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName="GST Number", ColumnModelName="GstNumber" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName = "Ship To Address", ColumnModelName = "ShipToAddress" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName = "Vehicle Number of Transporter", ColumnModelName = "VehicleNumberOfTransporter" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName = "Mobile Number of Truck Driver", ColumnModelName = "MobileNumberOfTruckDriver" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName = "Quantity(MT)", ColumnModelName = "QuantityInMT" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName = "Drums", ColumnModelName = "Drums" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName = "Net Weight Approx", ColumnModelName = "NetApprox" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName = "Loading From", ColumnModelName = "PortName" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName = "Mode/Terms of payment", ColumnModelName = "PaymentTermName" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName = "Rate + GST", ColumnModelName = "RateGst" }
                                    , new ScoPdfColumnsGenerationModel { ColumnName = "BL Number", ColumnModelName = "BLNumber" } };

            string scoPdfView = string.Empty;
            sCOGenerations[0].NetApprox = sCOGenerations[0].QuantityInMT / sCOGenerations[0].Drums;
            var xx = sCOGenerations[0].GstNumber;
            var typeOfClass = typeof(SCOGenerationsOutputModel);
            PropertyInfo dataProp;
            object data;
            var table = "<table style=\"width: 100%; border-collapse: collapse;\"><tr>";
            table += "<th class=\"form-v-table\"style=\"background-color:#cececa\">Fields</th><th class=\"form-v-table\"style=\"background-color:#cececa\">Value</th></tr>";
            foreach (var columnName in columnNames)
            {
                dataProp = typeOfClass.GetProperty(columnName.ColumnModelName);
                data = dataProp.GetValue(sCOGenerations[0]);
                //scoPdfView += "<p>" + columnName.ColumnName + "   :   " + data + "</p>";
                table += "<tr><td class=\"form-v-table\">" + columnName.ColumnName + "</td>";
                table += "<td class=\"form-v-table\">" + data + "</td>";
                table += "</tr>";
            }
            table += "</table>";

            CompanyThemeModel companyTheme = _companyStructureService.GetCompanyTheme(loggedInContext?.LoggedInUserId);
            var CompanyLogo = companyTheme.CompanyMainLogo != null ? companyTheme.CompanyMainLogo : "http://todaywalkins.com/Comp_images/Snovasys.png";

            var html = _goalRepository.GetHtmlTemplateByName("SCO Template", loggedInContext.CompanyGuid).Replace("##invoicePDFJson##", table).Replace("##CompanyLogo##", CompanyLogo);

            var pdfOutput = await _chromiumService.GeneratePdf(html, null, "SCO Acceptance");

            CompanyOutputModel companyModel = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

            var companySettingsSearchInputModel = new CompanySettingsSearchInputModel();
            companySettingsSearchInputModel.CompanyId = companyModel?.CompanyId;
            companySettingsSearchInputModel.IsSystemApp = null;
            string storageAccountName = string.Empty;

            List<CompanySettingsSearchOutputModel> companySettings = _masterDataManagementRepository.GetCompanySettings(companySettingsSearchInputModel, loggedInContext, validationMessages).ToList();
            if (companySettings.Count > 0)
            {
                var storageAccountDetails = companySettings.Where(x => x.Key == "StorageAccountName").FirstOrDefault();
                storageAccountName = storageAccountDetails?.Value;
            }

            var directory = SetupCompanyFileContainer(companyModel, 6, loggedInContext.LoggedInUserId, storageAccountName);

            var fileName = "SCO Acceptance";

            LoggingManager.Debug("UploadCourseFile input fileName:" + fileName);

            fileName = fileName.Replace(" ", "_");

            var fileExtension = ".pdf";

            var convertedFileName = fileName + "-" + Guid.NewGuid() + fileExtension;

            CloudBlockBlob blockBlob = directory.GetBlockBlobReference(convertedFileName);

            blockBlob.Properties.CacheControl = "public, max-age=2592000";

            blockBlob.Properties.ContentType = "application/pdf";

            Byte[] bytes = pdfOutput.ByteStream;

            blockBlob.UploadFromByteArray(bytes, 0, bytes.Length);

            var fileurl = blockBlob.Uri.AbsoluteUri;

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SCOAcceptanceMail", "Client Service"));

            LoggingManager.Debug(pdfOutput.ByteStream.ToString());

            SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, HttpContext.Current.Request.Url.Authority);

            Stream stream = new MemoryStream(pdfOutput.ByteStream);

            List<Stream> fileStream = new List<Stream>();

            fileStream.Add(stream);
            try
            {
                foreach (var member in sendSCOAcceptanceMailInputModel)
                {
                    var AcceptAddress = "";
                    var messageBody = "";
                    if (member.UserId == null)
                    {
                         AcceptAddress = "https://whform.nxusworld.com/?leadId=" + member.LeadId;
                         messageBody = "Click the URL "
                           + AcceptAddress + " to see the warehouse details in the form. Thank you!";
                    }
                    else
                    {
                         AcceptAddress = "https://whform.nxusworld.com/?leadId=" + member.LeadId + "&userId=" + member.UserId;
                         messageBody = "Please complete the steps for the order fulfilment from our warehouse and Click the URL "
                            + AcceptAddress + " to update final details in the form. Thank you!";
                    }

                    string mobileNo = member.MobileNo;
                    if (member.MobileNo != null)
                    {
                        _emailService.SendSMS(mobileNo, messageBody, loggedInContext);
                    }
                    var pdfHtml = _goalRepository.GetHtmlTemplateByName("WH Mail Template", loggedInContext.CompanyGuid)
                                    .Replace("##PdfUrl##", fileurl).Replace("##ScoAddress##", AcceptAddress)
                                    .Replace("##ToName##", member.UserName !=null ? member.UserName : null);
                    if(member.Email != null)
                    {
                        TaskWrapper.ExecuteFunctionInNewThread(() =>
                        {
                            EmailGenericModel emailModel = new EmailGenericModel
                            {
                                SmtpServer = smtpDetails?.SmtpServer,
                                SmtpServerPort = smtpDetails?.SmtpServerPort,
                                SmtpMail = smtpDetails?.SmtpMail,
                                SmtpPassword = smtpDetails?.SmtpPassword,
                                ToAddresses = member.Email.Trim().Split('\n'),
                                HtmlContent = pdfHtml,
                                Subject = "SCO details for execution",
                                MailAttachments = fileStream,
                                IsPdf = true
                            };
                            _emailService.SendMail(loggedInContext, emailModel);
                        });
                    }

                }
            }
            catch (Exception exception)
            {
                LoggingManager.Debug("SCO WH mail and SMS:" + exception);
            }

            return fileurl;
        }

        public Guid? UpsertProductList(MasterProduct masterProductModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Product List", "UpsertProductList", masterProductModel, "Upsert Product List"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            masterProductModel.ProductId = _clientRepository.UpsertProductList(masterProductModel, loggedInContext, validationMessages);


            _auditService.SaveAudit(AppCommandConstants.UpsertAccessibleIpAddressesCommandId, masterProductModel, loggedInContext);

            return masterProductModel.ProductId;
        }

        public Guid? UpsertMasterContractDetails(MasterContractInputModel masterProductModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Product List", "UpsertProductList", masterProductModel, "Upsert Product List"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            masterProductModel.ContractId = _clientRepository.UpsertMasterContractDetails(masterProductModel, loggedInContext, validationMessages);


            _auditService.SaveAudit(AppCommandConstants.UpsertAccessibleIpAddressesCommandId, masterProductModel, loggedInContext);

            return masterProductModel.ContractId;
        }

        public virtual List<ProductListOutPutModel> GetProductsList(MasterProduct masterProductModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetProductsList", "Client Service"));

            List<ProductListOutPutModel> productList = _clientRepository.GetProductsList(masterProductModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.GetSCosCommandId, masterProductModel, loggedInContext);

            return productList;
        }
        public Guid? UpsertGrades(GradeInputModel gradeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertGrade", "PayRoll Service"));

            LoggingManager.Debug(gradeInputModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            Guid? result = _clientRepository.UpsertGrades(gradeInputModel, loggedInContext, validationMessages);
            return result;
        }

        public List<GradeOutputModel> GetAllGrades(GradeInputModel gradeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetGrades", "PayRoll Service"));

            LoggingManager.Debug(gradeInputModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<GradeOutputModel> result = _clientRepository.GetAllGrades(gradeInputModel, loggedInContext, validationMessages).ToList();
            return result;
        }

        public List<CreditLimitLogsModel> GetAllCreditLogs(CreditLimitLogsModel creditLimitLogsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetGrades", "PayRoll Service"));

            List<CreditLimitLogsModel> result = _clientRepository.GetAllCreditLogs(creditLimitLogsModel, loggedInContext, validationMessages).ToList();
            return result;
        }

        public List<UserDbEntity> GetWareHoseUsers(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetGrades", "PayRoll Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<UserDbEntity> result = _clientRepository.GetWareHoseUsers(loggedInContext, validationMessages).ToList();
            return result;
        }

        public static string NumberToWords(int number)
        {
            if (number == 0)
                return "zero";

            if (number < 0)
                return "minus " + NumberToWords(Math.Abs(number));

            string words = "";

            if ((number / 1000000) > 0)
            {
                words += NumberToWords(number / 1000000) + " million ";
                number %= 1000000;
            }

            if ((number / 1000) > 0)
            {
                words += NumberToWords(number / 1000) + " thousand ";
                number %= 1000;
            }

            if ((number / 100) > 0)
            {
                words += NumberToWords(number / 100) + " hundred ";
                number %= 100;
            }

            if (number > 0)
            {
                if (words != "")
                    words += "and ";

                var unitsMap = new[] { "Zero", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "eighteen", "Nineteen" };
                var tensMap = new[] { "Zero", "Ten", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety" };

                if (number < 20)
                    words += unitsMap[number];
                else
                {
                    words += tensMap[number / 10];
                    if ((number % 10) > 0)
                        words += " " + unitsMap[number % 10];
                }
            }

            return words;
        }
        public Guid? UpsertPurchaseContract(MasterContractInputModel masterProductModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertPurchaseContract", "UpsertPurchaseContract", masterProductModel, "UpsertPurchaseContract"));

            if (!ClientValidations.ValidateUpsertPurchaseContract(masterProductModel, loggedInContext, validationMessages))
            {
                return null;
            }

            masterProductModel.ContractId = _clientRepository.UpsertPurchaseContract(masterProductModel, loggedInContext, validationMessages);


            _auditService.SaveAudit(AppCommandConstants.UpsertPurchaseContractCommandId, masterProductModel, loggedInContext);

            return masterProductModel.ContractId;
        }

        public List<MasterContractOutputModel> GetPurchaseContract(MasterContractInputModel clientInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPurchaseContract", "Client Service"));

            List<MasterContractOutputModel> purchasesList = _clientRepository.GetPurchaseContract(clientInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.GetPurchaseContractCommandId, clientInputModel, loggedInContext);

            return purchasesList;
        }

        public Guid? UpsertShipmentExecutions(PurchaseShipmentExecutionInputModel purchaseShipmentExecutionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertShipmentExecutions", "purchaseShipmentExecutionInputModel", purchaseShipmentExecutionInputModel, "UpsertShipmentExecutions"));

            if (!ClientValidations.ValidateUpsertShipmentExecutions(purchaseShipmentExecutionInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            purchaseShipmentExecutionInputModel.PurchaseShipmentId = _clientRepository.UpsertShipmentExecutions(purchaseShipmentExecutionInputModel, loggedInContext, validationMessages);

            if (purchaseShipmentExecutionInputModel.IsSendNotification == true && purchaseShipmentExecutionInputModel.WorkEmployeeId != null)
            {
                TaskWrapper.ExecuteFunctionInNewThread(() =>
                {
                    _notificationService.SendNotification(new NotificationModelForPurchaseExecution(
                          string.Format(NotificationSummaryConstants.PurchaseShipmentNotification,
                              purchaseShipmentExecutionInputModel.ShipmentNumber), purchaseShipmentExecutionInputModel.PurchaseShipmentId, purchaseShipmentExecutionInputModel.ContractId,
                          purchaseShipmentExecutionInputModel.ShipmentNumber, purchaseShipmentExecutionInputModel.WorkEmployeeId), loggedInContext, purchaseShipmentExecutionInputModel.WorkEmployeeId);
                });

                EmployeeDetailsApiReturnModel employeeDetailsApiReturnModel = new EmployeeDetailsApiReturnModel();
                EmployeeDetailSearchCriteriaInputModel employeeDetailSearchCriteriaInputModel = new EmployeeDetailSearchCriteriaInputModel();
                employeeDetailSearchCriteriaInputModel.EmployeeId = purchaseShipmentExecutionInputModel.EmployeeId;
                employeeDetailsApiReturnModel.employeeContactDetails = _employeeContactDetailRepository.GetEmployeeContactDetails(employeeDetailSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
                
                if(employeeDetailsApiReturnModel.employeeContactDetails.Count > 0)
                {
                    string mobileNo = employeeDetailsApiReturnModel.employeeContactDetails[0].CountryCode + purchaseShipmentExecutionInputModel.MobileNo;

                    string messageBody = "You have assigned as duty employee for BoE " + purchaseShipmentExecutionInputModel.ShipmentNumber;
                    if (purchaseShipmentExecutionInputModel.MobileNo != null)
                        _emailService.SendSMS(mobileNo, messageBody, loggedInContext);
                }

                var siteDomain = ConfigurationManager.AppSettings["SiteUrl"];
                var Address = siteDomain + "/billingmanagement/shipmentExecution/" + purchaseShipmentExecutionInputModel.ContractId + '/' + purchaseShipmentExecutionInputModel.PurchaseShipmentId;

                var pdfHtml = _goalRepository.GetHtmlTemplateByName("Duty Employee Template", loggedInContext.CompanyGuid)
                                    .Replace("##Employee##", purchaseShipmentExecutionInputModel.EmployeeName).Replace("##ShipmentNumber##", purchaseShipmentExecutionInputModel.ShipmentNumber)
                                    .Replace("##PurchaseExecutionUrl##", Address);

                SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, HttpContext.Current.Request.Url.Authority);

                TaskWrapper.ExecuteFunctionInNewThread(() =>
                {
                    EmailGenericModel emailModel = new EmailGenericModel
                    {
                        SmtpServer = smtpDetails?.SmtpServer,
                        SmtpServerPort = smtpDetails?.SmtpServerPort,
                        SmtpMail = smtpDetails?.SmtpMail,
                        SmtpPassword = smtpDetails?.SmtpPassword,
                        ToAddresses = purchaseShipmentExecutionInputModel.EmployeeEmailId.Trim().Split('\n'),
                        HtmlContent = pdfHtml,
                        Subject = "Duty Employee Assignee",
                        MailAttachments = null,
                        IsPdf = true
                    };
                    _emailService.SendMail(loggedInContext, emailModel);
                });
            }
            _auditService.SaveAudit(AppCommandConstants.UpsertShipmentExecutionsCommandId, purchaseShipmentExecutionInputModel, loggedInContext);

            return purchaseShipmentExecutionInputModel.PurchaseShipmentId;
        }

        public async Task<string> ShipmentExecutionBCHALMail(PurchaseShipmentExecutionBLInputModel purchaseShipmentExecutionBLInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ShipmentExecutionsMail", "Invoice Service"));
            {
                PurchaseShipmentExecutionSearchInputModel purchaseShipmentExecutionSearchInputModel = new PurchaseShipmentExecutionSearchInputModel();
                purchaseShipmentExecutionSearchInputModel.PurchaseShipmentBLId = purchaseShipmentExecutionBLInputModel.ShipmentBLId;
                PurchaseShipmentExecutionBLSearchOutputModel purchaseShipmentExecutionBL = GetShipmentExecutionBLById(purchaseShipmentExecutionSearchInputModel, loggedInContext, validationMessages);
                CompanyThemeModel companyTheme = _companyStructureService.GetCompanyTheme(loggedInContext?.LoggedInUserId);
                var CompanyLogo = companyTheme.CompanyMainLogo != null ? companyTheme.CompanyMainLogo : "http://todaywalkins.com/Comp_images/Snovasys.png";
                CompanyOutputModel companyModel = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);
                var companySettingsSearchInputModel = new CompanySettingsSearchInputModel();
                companySettingsSearchInputModel.CompanyId = companyModel?.CompanyId;
                companySettingsSearchInputModel.IsSystemApp = null;
                string storageAccountName = string.Empty;

                List<CompanySettingsSearchOutputModel> companySettings = _masterDataManagementRepository.GetCompanySettings(companySettingsSearchInputModel, loggedInContext, validationMessages).ToList();
                if (companySettings.Count > 0)
                {
                    var storageAccountDetails = companySettings.Where(x => x.Key == "StorageAccountName").FirstOrDefault();
                    storageAccountName = storageAccountDetails?.Value;
                }
                var directory = SetupCompanyFileContainer(companyModel, 6, loggedInContext.LoggedInUserId, storageAccountName);

                var fileExtension = ".pdf";

                var convertedFileName = purchaseShipmentExecutionBL.ShipmentBLId.ToString().Replace(" ", "_") + "-" + Guid.NewGuid() + fileExtension;

                LoggingManager.Debug("ShipmentExecution Upload input fileName:" + convertedFileName);

                CloudBlockBlob blockBlob = directory.GetBlockBlobReference(convertedFileName);

                blockBlob.Properties.CacheControl = "public, max-age=2592000";

                blockBlob.Properties.ContentType = "application/pdf";

                var html = _goalRepository.GetHtmlTemplateByName("PurchaseShipmentCHAPDFTemplate", loggedInContext.CompanyGuid).Replace("##ShipmentNumber##", purchaseShipmentExecutionBL.ShipmentNumber)
                    .Replace("##VesselName##", purchaseShipmentExecutionBL.VesselName)
                    .Replace("##VoyageNumber##", purchaseShipmentExecutionBL.VoyageNumber)
                    .Replace("##BLNumber##", purchaseShipmentExecutionBL.BLNumber)
                    .Replace("##BLDate##", purchaseShipmentExecutionBL.BLDate?.ToString("dd-MMM-yyyy"))
                    .Replace("##BLQty##", purchaseShipmentExecutionBL.BLQuantity.ToString())
                    .Replace("##BLPrice##", purchaseShipmentExecutionBL.Price.ToString())
                    .Replace("##BLValue##", (purchaseShipmentExecutionBL.BLQuantity * purchaseShipmentExecutionBL.Price).ToString())
                    .Replace("##Product##", purchaseShipmentExecutionBL.Product)
                    .Replace("##Grade##", purchaseShipmentExecutionBL.Grade)
                    .Replace("##VesselETA##", purchaseShipmentExecutionBL.ETADate?.ToString("dd-MMM-yyyy"))
                    .Replace("##LoadingPort##", purchaseShipmentExecutionBL.LoadName)
                    .Replace("##DischargePort##", purchaseShipmentExecutionBL.DischargeName);
                var pdfHtml = _goalRepository.GetHtmlTemplateByName("SCO Template", loggedInContext.CompanyGuid).Replace("##invoicePDFJson##", html).Replace("##CompanyLogo##", CompanyLogo); ;
                var purchaseShipmentCHAPdfOutput = await _chromiumService.GeneratePdf(pdfHtml, null, purchaseShipmentExecutionBL.ShipmentBLId.ToString());

                Byte[] bytes = purchaseShipmentCHAPdfOutput.ByteStream;

                blockBlob.UploadFromByteArray(bytes, 0, bytes.Length);

                var fileurl = blockBlob.Uri.AbsoluteUri;

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DownloadOrSendPdfInvoice", "Invoice Service"));

                LoggingManager.Debug(purchaseShipmentCHAPdfOutput.ByteStream.ToString());

                Stream stream = new MemoryStream(purchaseShipmentCHAPdfOutput.ByteStream);

                var purchaseShipmentCHAFileName = "Purchase Shipment CHA";

                var purchaseShipmentCHAConvertedFileName = purchaseShipmentCHAFileName + "-" + purchaseShipmentExecutionBL.BLNumber + fileExtension;

                CloudBlockBlob purchaseShipmentCHABlockBlob = directory.GetBlockBlobReference(purchaseShipmentCHAConvertedFileName);

                purchaseShipmentCHABlockBlob.Properties.CacheControl = "public, max-age=2592000";

                purchaseShipmentCHABlockBlob.Properties.ContentType = "application/pdf";

                Byte[] purchaseShipmentCHABytes = purchaseShipmentCHAPdfOutput.ByteStream;

                purchaseShipmentCHABlockBlob.UploadFromByteArray(purchaseShipmentCHABytes, 0, purchaseShipmentCHABytes.Length);

                Stream purchaseShipmentCHAStream = new MemoryStream(purchaseShipmentCHAPdfOutput.ByteStream);

                var purchaseShipmentCHAUrl = purchaseShipmentCHABlockBlob.Uri.AbsoluteUri;

                List<StreamWithType> fileStream = new List<StreamWithType>();
                fileStream.Add(new StreamWithType() { FileStream = purchaseShipmentCHAStream, FileName = purchaseShipmentCHAConvertedFileName, FileType = ".pdf", IsPdf = true });

                var documents = new List<InitialDocumentsDescription>();
                PurchaseShipmentExecutionBLSearchOutputModel ShipmentExecutionBLsList = GetBlDescriptions(purchaseShipmentExecutionSearchInputModel, loggedInContext, validationMessages);
                var documentType = "Initial documents";
                if (purchaseShipmentExecutionBLInputModel.IsInitialDocumentsMail == true)
                {
                    documents = ShipmentExecutionBLsList.InitialDocumentsDescriptions;
                    documentType = "Initial documents";
                }
                else if (purchaseShipmentExecutionBLInputModel.IsInitialDocumentsMail == false)
                {
                    documents = ShipmentExecutionBLsList.FinalDocumentsDescriptions;
                    documentType = "Final documents";
                }
                else
                {
                    return "";
                }
                if (documents != null)
                {
                    foreach (var doc in documents)
                    {
                        List<FileApiReturnModel> files = new List<FileApiReturnModel>();
                        files = _fileService.SearchFile(new FileSearchCriteriaInputModel() { ReferenceId = doc.Id, IsArchived = false }, loggedInContext, validationMessages);
                        if (files.Count > 0)
                        {
                            foreach (var file in files)
                            {
                                var webClient = new WebClient();
                                byte[] fileBytes1 = webClient.DownloadData(file.FilePath);

                                Stream stream1 = new MemoryStream(fileBytes1);
                                var ispdf = false;
                                var isExcel = false;
                                var isJpg = false;
                                var isJpeg = false;
                                var isPng = false;
                                var isDocx = false;
                                var isTxt = false;

                                if (file.FileExtension.Contains(".pdf"))
                                {
                                    ispdf = true;
                                }
                                else if (file.FileExtension.Contains(".xlsx"))
                                {
                                    isExcel = true;
                                }
                                else if (file.FileExtension.Contains(".jpg"))
                                {
                                    isJpg = true;
                                }
                                else if (file.FileExtension.Contains(".jpeg"))
                                {
                                    isJpeg = true;
                                }
                                else if (file.FileExtension.Contains(".png"))
                                {
                                    isPng = true;
                                }
                                else if (file.FileExtension.Contains(".docx"))
                                {
                                    isDocx = true;
                                }
                                else if (file.FileExtension.Contains(".txt"))
                                {
                                    isTxt = true;
                                }

                                fileStream.Add(new StreamWithType() { FileStream = stream1, FileType = file.FileExtension, IsPdf = ispdf, IsExcel = isExcel, IsJpeg = isJpeg, IsJpg = isJpg, IsPng = isPng, IsDocx = isDocx, IsTxt = isTxt, FileName = file.FileName });
                            }
                        }

                    }
                }
                List<UserOutputModel> usersList = _userRepository.GetAllUsers(
                new Models.User.UserSearchCriteriaInputModel
                {
                    UserId = purchaseShipmentExecutionBLInputModel.ChaId
                }, loggedInContext, validationMessages);
                var toEmails = usersList[0].Email.Trim().Split('\n');

                var body = _goalRepository.GetHtmlTemplateByName("PurchaseShipmentCHATemplate", loggedInContext.CompanyGuid).Replace("##ToName##", usersList[0].FullName)
                    .Replace("##DocumentType##", documentType).Replace("##BLNumber##", purchaseShipmentExecutionBL.BLNumber);


                SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, HttpContext.Current.Request.Url.Authority);
                TaskWrapper.ExecuteFunctionInNewThread(() =>
                {
                    EmailGenericModel emailModel = new EmailGenericModel
                    {
                        SmtpServer = smtpDetails?.SmtpServer,
                        SmtpServerPort = smtpDetails?.SmtpServerPort,
                        SmtpMail = smtpDetails?.SmtpMail,
                        SmtpPassword = smtpDetails?.SmtpPassword,
                        ToAddresses = toEmails,
                        HtmlContent = body,
                        Subject = documentType + " of " + purchaseShipmentExecutionBL.BLNumber,
                        MailAttachments = null,
                        MailAttachmentsWithFileType = fileStream,
                        IsPdf = true
                    };
                    _emailService.SendMail(loggedInContext, emailModel);
                });

                return fileurl;
            }
        }

        public List<PurchaseShipmentExecutionSearchOutputModel> GetShipmentExecutions(PurchaseShipmentExecutionSearchInputModel purchaseShipmentExecutionSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetShipmentExecutions", "Client Service"));

            List<PurchaseShipmentExecutionSearchOutputModel> ShipmentExecutionsList = _clientRepository.GetShipmentExecutions(purchaseShipmentExecutionSearchInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.GetShipmentExecutionsCommandId, purchaseShipmentExecutionSearchInputModel, loggedInContext);

            return ShipmentExecutionsList;
        }
        public async Task<Guid?> UpsertShipmentExecutionBL(PurchaseShipmentExecutionBLInputModel purchaseShipmentExecutionBLInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertShipmentExecutionBL", "purchaseShipmentExecutionBLInputModel", purchaseShipmentExecutionBLInputModel, "UpsertShipmentExecutions"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            purchaseShipmentExecutionBLInputModel.ShipmentBLId = _clientRepository.UpsertShipmentExecutionBL(purchaseShipmentExecutionBLInputModel, loggedInContext, validationMessages);
            if (purchaseShipmentExecutionBLInputModel.ChaId != null && purchaseShipmentExecutionBLInputModel.ChaId != Guid.Empty && purchaseShipmentExecutionBLInputModel.IsInitialDocumentsMail != null)
            {
                string file = await ShipmentExecutionBCHALMail(purchaseShipmentExecutionBLInputModel, loggedInContext, validationMessages);
            }


            _auditService.SaveAudit(AppCommandConstants.UpsertShipmentExecutionBLCommandId, purchaseShipmentExecutionBLInputModel, loggedInContext);

            return purchaseShipmentExecutionBLInputModel.ShipmentBLId;
        }
        public Guid? UpsertBlDescription(PurchaseShipmentExecutionBLInputModel purchaseShipmentExecutionBLInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertBlDescription", "purchaseShipmentExecutionBLInputModel", purchaseShipmentExecutionBLInputModel, "UpsertShipmentExecutions"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            if (purchaseShipmentExecutionBLInputModel.InitialDocumentsDescription != null && purchaseShipmentExecutionBLInputModel.InitialDocumentsDescription.Count > 0)
            {
                purchaseShipmentExecutionBLInputModel.InitialDocumentsDescriptionsXml = Utilities.GetXmlFromObject(purchaseShipmentExecutionBLInputModel.InitialDocumentsDescription);
            }
            else
            {
                purchaseShipmentExecutionBLInputModel.InitialDocumentsDescriptionsXml = null;
            }
            if (purchaseShipmentExecutionBLInputModel.FinalDocumentsDescription != null && purchaseShipmentExecutionBLInputModel.FinalDocumentsDescription.Count > 0)
            {
                purchaseShipmentExecutionBLInputModel.FinalDocumentsDescriptionsXml = Utilities.GetXmlFromObject(purchaseShipmentExecutionBLInputModel.FinalDocumentsDescription);
            }
            else
            {
                purchaseShipmentExecutionBLInputModel.FinalDocumentsDescriptionsXml = null;
            }

            purchaseShipmentExecutionBLInputModel.ShipmentBLId = _clientRepository.UpsertBlDescription(purchaseShipmentExecutionBLInputModel, loggedInContext, validationMessages);


            _auditService.SaveAudit(AppCommandConstants.UpsertShipmentExecutionBLCommandId, purchaseShipmentExecutionBLInputModel, loggedInContext);

            return purchaseShipmentExecutionBLInputModel.ShipmentBLId;
        }
        public PurchaseShipmentExecutionBLSearchOutputModel GetBlDescriptions(PurchaseShipmentExecutionSearchInputModel purchaseShipmentExecutionSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetBlDescriptions", "Client Service"));
            if (!ClientValidations.ValidateGetShipmentExecutionBLById(purchaseShipmentExecutionSearchInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            PurchaseShipmentExecutionBLSearchOutputModel ShipmentExecutionBLsList = _clientRepository.GetBlDescriptions(purchaseShipmentExecutionSearchInputModel, loggedInContext, validationMessages);
            if (ShipmentExecutionBLsList != null && ShipmentExecutionBLsList.InitialDocumentsDescriptionXml != null)
            {
                ShipmentExecutionBLsList.InitialDocumentsDescriptions = Utilities.GetObjectFromXml<InitialDocumentsDescription>(ShipmentExecutionBLsList.InitialDocumentsDescriptionXml, "InitialDocumentsDescription");
            }
            if (ShipmentExecutionBLsList != null && ShipmentExecutionBLsList.FinalDocumentsDescriptionXml != null)
            {
                ShipmentExecutionBLsList.FinalDocumentsDescriptions = Utilities.GetObjectFromXml<InitialDocumentsDescription>(ShipmentExecutionBLsList.FinalDocumentsDescriptionXml, "FinalDocumentsDescription");
            }
            _auditService.SaveAudit(AppCommandConstants.GetShipmentExecutionBLsCommandId, purchaseShipmentExecutionSearchInputModel, loggedInContext);

            return ShipmentExecutionBLsList;
        }
        public Guid? UpsertDocumentsDescription(PurchaseShipmentExecutionBLInputModel purchaseShipmentExecutionBLInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertDocumentsDescription", "purchaseShipmentExecutionBLInputModel", purchaseShipmentExecutionBLInputModel, "UpsertShipmentExecutions"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            if (purchaseShipmentExecutionBLInputModel.InitialDocumentsDescription != null && purchaseShipmentExecutionBLInputModel.InitialDocumentsDescription.Count > 0)
            {
                purchaseShipmentExecutionBLInputModel.InitialDocumentsDescriptionsXml = Utilities.GetXmlFromObject(purchaseShipmentExecutionBLInputModel.InitialDocumentsDescription);
            }
            else
            {
                purchaseShipmentExecutionBLInputModel.InitialDocumentsDescriptionsXml = null;
            }

            purchaseShipmentExecutionBLInputModel.ShipmentBLId = _clientRepository.UpsertDocumentsDescription(purchaseShipmentExecutionBLInputModel, loggedInContext, validationMessages);


            _auditService.SaveAudit(AppCommandConstants.UpsertShipmentExecutionBLCommandId, purchaseShipmentExecutionBLInputModel, loggedInContext);

            return purchaseShipmentExecutionBLInputModel.ShipmentBLId;
        }
        public PurchaseShipmentExecutionBLSearchOutputModel GetDocumentsDescriptions(Guid referenceTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDocumentsDescriptions", "Client Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            PurchaseShipmentExecutionBLSearchOutputModel ShipmentExecutionBLsList = _clientRepository.GetDocumentsDescriptions(referenceTypeId, loggedInContext, validationMessages);
            if (ShipmentExecutionBLsList != null && ShipmentExecutionBLsList.InitialDocumentsDescriptionXml != null)
            {
                ShipmentExecutionBLsList.InitialDocumentsDescriptions = Utilities.GetObjectFromXml<InitialDocumentsDescription>(ShipmentExecutionBLsList.InitialDocumentsDescriptionXml, "InitialDocumentsDescription");
            }
            _auditService.SaveAudit(AppCommandConstants.GetShipmentExecutionBLsCommandId, referenceTypeId, loggedInContext);

            return ShipmentExecutionBLsList;
        }
        public List<PurchaseShipmentExecutionBLSearchOutputModel> GetShipmentExecutionBLs(PurchaseShipmentExecutionSearchInputModel purchaseShipmentExecutionSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetShipmentExecutionBLs", "Client Service"));
            if (!ClientValidations.ValidateGetShipmentExecutionBLs(purchaseShipmentExecutionSearchInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            List<PurchaseShipmentExecutionBLSearchOutputModel> ShipmentExecutionBLsList = _clientRepository.GetShipmentExecutionBLs(purchaseShipmentExecutionSearchInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.GetShipmentExecutionBLsCommandId, purchaseShipmentExecutionSearchInputModel, loggedInContext);

            return ShipmentExecutionBLsList;
        }
        public PurchaseShipmentExecutionBLSearchOutputModel GetShipmentExecutionBLById(PurchaseShipmentExecutionSearchInputModel purchaseShipmentExecutionSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetShipmentExecutionBLById", "Client Service"));
            if (!ClientValidations.ValidateGetShipmentExecutionBLById(purchaseShipmentExecutionSearchInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            PurchaseShipmentExecutionBLSearchOutputModel ShipmentExecutionBL = _clientRepository.GetShipmentExecutionBLById(purchaseShipmentExecutionSearchInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.GetShipmentExecutionBLByIdCommandId, purchaseShipmentExecutionSearchInputModel, loggedInContext);

            return ShipmentExecutionBL;
        }

        public Guid? UpsertVessels(VesselModel vesselModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertVessels", "Client Service"));

            LoggingManager.Debug(vesselModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            Guid? result = _clientRepository.UpsertVessels(vesselModel, loggedInContext, validationMessages);
            return result;
        }

        public List<VesselModel> GetAllVessels(VesselModel vesselModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetGrades", "PayRoll Service"));

            LoggingManager.Debug(vesselModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<VesselModel> result = _clientRepository.GetAllVessels(vesselModel, loggedInContext, validationMessages).ToList();
            return result;
        }

        public Guid? SendChaConfirmationMail(PurchaseShipmentExecutionBLInputModel PurchaseShipmentExecutionBLInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            Guid? ChaId = PurchaseShipmentExecutionBLInputModel.ChaId;
            var pdfHtml = _goalRepository.GetHtmlTemplateByName("CHAConfirmationTemplate", loggedInContext.CompanyGuid)
                                    .Replace("##BLNumber##", PurchaseShipmentExecutionBLInputModel.BLNumber);

            SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, HttpContext.Current.Request.Url.Authority);

            TaskWrapper.ExecuteFunctionInNewThread(() =>
            {
                EmailGenericModel emailModel = new EmailGenericModel
                {
                    SmtpServer = smtpDetails?.SmtpServer,
                    SmtpServerPort = smtpDetails?.SmtpServerPort,
                    SmtpMail = smtpDetails?.SmtpMail,
                    SmtpPassword = smtpDetails?.SmtpPassword,
                    ToAddresses = PurchaseShipmentExecutionBLInputModel.ChaEmail.Trim().Split('\n'),
                    HtmlContent = pdfHtml,
                    Subject = "CHA Confirmation",
                    MailAttachments = null,
                    IsPdf = true
                };
                _emailService.SendMail(loggedInContext, emailModel);
            });
            return ChaId;
        }

        public Guid? UpsertLegalEntity(LegalEntityModel legalEntityModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertVessels", "Client Service"));

            LoggingManager.Debug(legalEntityModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            Guid? result = _clientRepository.UpsertLegalEntity(legalEntityModel, loggedInContext, validationMessages);
            return result;
        }

        public List<LegalEntityModel> GetAllLegalEntities(LegalEntityModel legalEntityModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllLegalEntities", "Client Service"));

            LoggingManager.Debug(legalEntityModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<LegalEntityModel> result = _clientRepository.GetAllLegalEntities(legalEntityModel, loggedInContext, validationMessages).ToList();
            return result;
        }

        public List<ClientOutputModel> GetClientKycDetails(ClientInputModel clientInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSCOGenerations", "Client Service"));

            List<ClientOutputModel> KycDetails = _clientRepository.GetClientKycDetails(clientInputModel, validationMessages);

            return KycDetails;
        }
        public Guid? UpsertKycDetails(ClientKycSubmissionDetails ClientKycSubmissionDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSCOGenerations", "Client Service"));

            ClientInputModel clientInputModel = new ClientInputModel();

            clientInputModel.ClientId = ClientKycSubmissionDetails.ClientId;

            Guid? ClientId = _clientRepository.UpsertKycDetails(ClientKycSubmissionDetails, loggedInContext, validationMessages);
            if(ClientKycSubmissionDetails !=null && ClientKycSubmissionDetails.ClientId != null)
            {
                loggedInContext.CompanyGuid = ClientKycSubmissionDetails.CompanyId;
                loggedInContext.LoggedInUserId = ClientKycSubmissionDetails.UserId;

                SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, null);

                CounterPartySettingsModel CounterPartySettingsModel = new CounterPartySettingsModel
                {
                    Key = "KYCSubmissionEmails",
                    IsArchived = false,
                    ClientId = ClientKycSubmissionDetails.ClientId
                };
                var ToEmails = _clientRepository.GetCounterPartySettings(CounterPartySettingsModel, loggedInContext, validationMessages).Select(x => x.Value).FirstOrDefault(); ;
                
                if(ToEmails != null)
                {
                    var EmailsList = ToEmails.Split(',');
                    var siteDomain = ConfigurationManager.AppSettings["SiteUrl"];
                    var SiteAddress = siteDomain + "/lives/editclientdetails/" + ClientKycSubmissionDetails.ClientId;
                    EmailTemplateModel EmailTemplateModel = new EmailTemplateModel
                    {
                        ClientId = ClientKycSubmissionDetails.ClientId,
                        EmailTemplateName = "KYCDetailsSubmittedTemplate"
                    };
                    var template = _clientRepository.GetAllEmailTemplates(EmailTemplateModel, loggedInContext, validationMessages).ToList()[0];

                    var pdfHtml = template.EmailTemplate
                                     .Replace("##ClientName##", ClientKycSubmissionDetails.FullName)
                                     .Replace("##SiteAddress##", SiteAddress)
                                     ;
                    TaskWrapper.ExecuteFunctionInNewThread(() =>
                    {
                        EmailGenericModel emailModel = new EmailGenericModel
                        {
                            SmtpServer = smtpDetails?.SmtpServer,
                            SmtpServerPort = smtpDetails?.SmtpServerPort,
                            SmtpMail = smtpDetails?.SmtpMail,
                            SmtpPassword = smtpDetails?.SmtpPassword,
                            ToAddresses = EmailsList,
                            HtmlContent = pdfHtml,
                            Subject = template.EmailSubject,//"KYC Submission",
                            MailAttachments = null,
                            IsPdf = true
                        };
                        _emailService.SendMail(loggedInContext, emailModel);
                    });
                }
            }
            
            //ClientOutputModel clientOutput = GetClients(clientInputModel, loggedInContext, validationMessages)?.FirstOrDefault();

            //if (clientOutput?.KycExpireDate == null)
            //{
            //    TaskWrapper.ExecuteFunctionInNewThread(() =>
            //    {
            //        BackgroundJob.Enqueue(() => SendClientRegistrationMail(clientOutput, loggedInContext, validationMessages));

            //    });
            //}

            return ClientId;
        }

        async public Task<Guid?> SendEmailForKycSubmission(UpsertClientInputModel upsertClientInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            Guid? ClientId = upsertClientInputModel.ClientId;
            var siteDomain = ConfigurationManager.AppSettings["SiteUrl"];
            var SiteAddress = siteDomain + "/client/kycDetailsSubmission/" + upsertClientInputModel.ClientId;
            EmailTemplateModel EmailTemplateModel = new EmailTemplateModel
            {
                ClientId = upsertClientInputModel.ClientId,
                EmailTemplateName = "KYCSubmissionTemplate"
            };
            var template = _clientRepository.GetAllEmailTemplates(EmailTemplateModel, loggedInContext, validationMessages).ToList()[0];

            var pdfHtml = template.EmailTemplate.Replace("##FullName##", upsertClientInputModel.FirstName + ' ' + upsertClientInputModel.LastName)
                                             .Replace("##SiteAddress##", SiteAddress)
                                             .Replace("##AddressLine1##", upsertClientInputModel.AddressLine1)
                                             .Replace("##AddressLine2##", upsertClientInputModel.AddressLine2)
                                             .Replace("##BusinessEmail##", upsertClientInputModel.BusinessEmail)
                                             .Replace("##BusinessNumber##", upsertClientInputModel.BusinessNumber)
                                             .Replace("##CompanyName##", upsertClientInputModel.CompanyName)
                                             .Replace("##CompanyWebsite##", upsertClientInputModel.CompanyWebsite)
                                             .Replace("##Email##", upsertClientInputModel.Email)
                                             .Replace("##GstNumber##", upsertClientInputModel.GstNumber)
                                             .Replace("##MobileNo##", upsertClientInputModel.MobileNo)
                                             .Replace("##Zipcode##", upsertClientInputModel.Zipcode);

            //var pdfHtml = _goalRepository.GetHtmlTemplateByName("KYCSubmissionTemplate", loggedInContext.CompanyGuid)
            //                             .Replace("##FullName##", upsertClientInputModel.FirstName + ' ' + upsertClientInputModel.LastName)
            //                             .Replace("##SiteAddress##", SiteAddress)
            //                             .Replace("##AddressLine1##", upsertClientInputModel.AddressLine1)
            //                             .Replace("##AddressLine2##", upsertClientInputModel.AddressLine2)
            //                             .Replace("##BusinessEmail##", upsertClientInputModel.BusinessEmail)
            //                             .Replace("##BusinessNumber##", upsertClientInputModel.BusinessNumber)
            //                             .Replace("##CompanyName##", upsertClientInputModel.CompanyName)
            //                             .Replace("##CompanyWebsite##", upsertClientInputModel.CompanyWebsite)
            //                             .Replace("##Email##", upsertClientInputModel.Email)
            //                             .Replace("##GstNumber##", upsertClientInputModel.GstNumber)
            //                             .Replace("##MobileNo##", upsertClientInputModel.MobileNo)
            //                             .Replace("##Zipcode##", upsertClientInputModel.Zipcode)
            //                             ;
            string[] toEmails = { upsertClientInputModel.BusinessEmail, upsertClientInputModel.Email };
            SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, HttpContext.Current.Request.Url.Authority);

            TaskWrapper.ExecuteFunctionInNewThread(() =>
            {
                EmailGenericModel emailModel = new EmailGenericModel
                {
                    SmtpServer = smtpDetails?.SmtpServer,
                    SmtpServerPort = smtpDetails?.SmtpServerPort,
                    SmtpMail = smtpDetails?.SmtpMail,
                    SmtpPassword = smtpDetails?.SmtpPassword,
                    ToAddresses = upsertClientInputModel.BusinessEmail != null ? toEmails : upsertClientInputModel.Email.Trim().Split('\n'),
                    HtmlContent = pdfHtml,
                    Subject = template.EmailSubject,// "KYC Submission",
                    MailAttachments = null,
                    IsPdf = true
                };
                _emailService.SendMail(loggedInContext, emailModel);
            });
            return ClientId;
        }


        public Guid? SendClientRegistrationMail(Guid? ClientId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, null);

            ClientInputModel clientInput = new ClientInputModel();
            clientInput.ClientId = ClientId;
            clientInput.IsForMail = true;

            ClientOutputModel clientOutputModel = GetClients(clientInput, loggedInContext, validationMessages)?.FirstOrDefault();

            if (clientOutputModel.IsFirstKYC == true)
            {

                CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

                var siteDomain = ConfigurationManager.AppSettings["SiteUrl"];

                HtmlTemplateSearchInputModel htmlTemplateSearchInputModel = new HtmlTemplateSearchInputModel()
                {
                    IsArchived = false,
                };

                var templates = _htmlTemplateRepository.GetHtmlTemplates(htmlTemplateSearchInputModel, loggedInContext, validationMessages);

                if (templates != null)
                {
                    CompanySettingsSearchInputModel companySettingMainLogoModel = new CompanySettingsSearchInputModel
                    {
                        Key = "CompanySigninLogo",
                        IsArchived = false
                    };

                    string mainLogo = (_masterDataManagementRepository.GetCompanySettings(companySettingMainLogoModel, loggedInContext, new List<ValidationMessage>())?.FirstOrDefault()?.Value);

                    var siteAddress = siteDomain + "/sessions/signin";

                    var html = _goalRepository.GetHtmlTemplateByName("ClientRegistrationMail", loggedInContext.CompanyGuid);

                    html = html.Replace("##UserName##", clientOutputModel?.Email).
                            Replace("##CompanyName##", smtpDetails.CompanyName).
                            Replace("##siteUrl##", siteAddress).
                            Replace("##Name##", clientOutputModel?.FirstName + " " + clientOutputModel?.LastName).
                            Replace("##Password##", "Test123!").
                            Replace("##CompanyRegistrationLogo##", mainLogo);

                    var toMails = new string[1];
                    toMails[0] = clientOutputModel.Email;
                    EmailGenericModel emailModel = new EmailGenericModel
                    {
                        SmtpServer = smtpDetails?.SmtpServer,
                        SmtpServerPort = smtpDetails?.SmtpServerPort,
                        SmtpMail = smtpDetails?.SmtpMail,
                        SmtpPassword = smtpDetails?.SmtpPassword,
                        ToAddresses = toMails,
                        HtmlContent = html,
                        Subject = "LIVES-KYC Verification Successful",
                        CCMails = null,
                        BCCMails = null,
                        MailAttachments = null,
                        IsPdf = null
                    };
                    _emailService.SendMail(loggedInContext, emailModel);
                    return ClientId;
                }
            }

            return ClientId;
        }

        public Guid? UpsertCounterPartySettings(CounterPartySettingsModel CounterPartySettingsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCounterPartySettings", "Client Service"));

            LoggingManager.Debug(CounterPartySettingsModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            Guid? result = _clientRepository.UpsertCounterPartySettings(CounterPartySettingsModel, loggedInContext, validationMessages);
            return result;
        }

        public List<CounterPartySettingsModel> GetCounterPartySettings(CounterPartySettingsModel CounterPartySettingsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCounterPartySettings", "Client Service"));

            List<CounterPartySettingsModel> CounterPartySettings = _clientRepository.GetCounterPartySettings(CounterPartySettingsModel, loggedInContext, validationMessages);

            return CounterPartySettings;
        }

        public Guid? UpsertKycStatus(KycFormStatusModel KycFormStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertKycStatus", "Client Service"));

            LoggingManager.Debug(KycFormStatusModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            Guid? result = _clientRepository.UpsertKycStatus(KycFormStatusModel, loggedInContext, validationMessages);
            return result;
        }

        public List<KycFormStatusModel> GetAllkycStatus(KycFormStatusModel legalEntityModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllLegalEntities", "Client Service"));

            LoggingManager.Debug(legalEntityModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<KycFormStatusModel> result = _clientRepository.GetAllkycStatus(legalEntityModel, loggedInContext, validationMessages).ToList();
            return result;
        }

        public List<KycFormHistoryModel> GetClientKycHistory(KycFormHistoryModel KycFormHistoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetKycFormHistory", "Client Service"));

            List<KycFormHistoryModel> result = _clientRepository.GetClientKycHistory(KycFormHistoryModel, loggedInContext, validationMessages).ToList();
            return result;
        }

        public void SendMailToKYCAlert()
        {
            ClientInputModel clientInput = new ClientInputModel();

            var validationMessages = new List<ValidationMessage>();

            List<CompanyOutputModel> companies = _companyStructureRepository.SearchCompanies(new CompanySearchCriteriaInputModel() { ForSuperUser = true }, validationMessages);

            if (companies != null && companies.Count > 0)
            {
                foreach (var c in companies)
                {
                    var owner = _userRepository.GetUserDetailsByName(c.WorkEmail, true).FirstOrDefault();

                    if (owner != null)
                    {
                        LoggedInContext loggedInContext = new LoggedInContext
                        {
                            LoggedInUserId = owner.Id,
                            CompanyGuid = owner.CompanyId
                        };

                        List<ClientOutputModel> clientOutputs = GetClients(clientInput, loggedInContext, validationMessages)?.Where(x => x.KycExpireDate?.AddDays(1).ToString("dd/M/yyyy", CultureInfo.InvariantCulture) == DateTime.Now.ToString("dd/M/yyyy", CultureInfo.InvariantCulture) && x.KycExpiryDays != 0)?.ToList();

                        SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, null);

                        var siteDomain = ConfigurationManager.AppSettings["SiteUrl"];

                        HtmlTemplateSearchInputModel htmlTemplateSearchInputModel = new HtmlTemplateSearchInputModel()
                        {
                            IsArchived = false,
                        };

                        var templates = _htmlTemplateRepository.GetHtmlTemplates(htmlTemplateSearchInputModel, loggedInContext, validationMessages);

                        if (templates != null)
                        {
                            CompanySettingsSearchInputModel companySettingMainLogoModel = new CompanySettingsSearchInputModel
                            {
                                Key = "CompanySigninLogo",
                                IsArchived = false
                            };

                            string mainLogo = (_masterDataManagementRepository.GetCompanySettings(companySettingMainLogoModel, loggedInContext, new List<ValidationMessage>())?.FirstOrDefault()?.Value);

                            var siteAddress = siteDomain + "/sessions/signin";

                            var html = _goalRepository.GetHtmlTemplateByName("ClientKYCAlertMail", loggedInContext.CompanyGuid);

                            html = html?.Replace("##CompanyName##", smtpDetails.CompanyName).
                                    Replace("##siteUrl##", siteAddress).
                                    Replace("##CompanyLogo##", mainLogo == null ? "https://bviewstorage.blob.core.windows.net/0e601206-1302-48e7-99b1-17c749785c6c/hrm/b02a868e-01f1-49bf-815e-6cd49a8d9f3b/0dbe22071b4839c0540c8561f2af7c1bdd0066ce-7e46a52d-21df-409b-9ad4-107c2cfa9a3e.png" : mainLogo);

                            foreach (var clients in clientOutputs)
                            {
                                var toMails = new string[1];

                                toMails[0] = clients.Email;

                                DateTime exeDate = Convert.ToDateTime(clients.KycExpireDate).Date;
                                TimeSpan ts = new TimeSpan(00, 00, 0);
                                exeDate = exeDate + ts;
                                int ustTime = -270;
                                int offSetMin = _userRepository.GetOffsetMinutes(clients.UserId);
                                if (offSetMin != 0)
                                    exeDate = exeDate.AddDays(1).AddMinutes(ustTime).AddMinutes(offSetMin);
                                else
                                    exeDate = exeDate.AddDays(1);

                                EmailGenericModel emailModel = new EmailGenericModel
                                {
                                    SmtpServer = smtpDetails?.SmtpServer,
                                    SmtpServerPort = smtpDetails?.SmtpServerPort,
                                    SmtpMail = smtpDetails?.SmtpMail,
                                    SmtpPassword = smtpDetails?.SmtpPassword,
                                    ToAddresses = toMails,
                                    HtmlContent = html,
                                    Subject = "KYC Expired Notification",
                                    CCMails = null,
                                    BCCMails = null,
                                    MailAttachments = null,
                                    IsPdf = null
                                };
                                //_emailService.SendMail(loggedInContext, emailModel);
                                var jobId = BackgroundJob.Schedule(() => _emailService.SendMail(loggedInContext, emailModel), exeDate);
                                ClientKycConfiguration clientKycConfiguration = new ClientKycConfiguration();
                                clientKycConfiguration.ClientId = clients.ClientId;
                                clientKycConfiguration.IsArchived = true;
                                var clientId = BackgroundJob.Schedule(() => _clientRepository.UpsertClientKycForm(clientKycConfiguration, loggedInContext, validationMessages), exeDate);
                                //var clientId = _clientRepository.UpsertClientKycForm(clientKycConfiguration, loggedInContext, validationMessages);
                            }
                        }

                    }

                }
            }


        }

        public Guid? UpsertTemplateConfiguration(TemplateConfigurationModel TemplateConfigurationModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertTemplateConfiguration", "Client Service"));

            LoggingManager.Debug(TemplateConfigurationModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            Guid? result = _clientRepository.UpsertTemplateConfiguration(TemplateConfigurationModel, loggedInContext, validationMessages);
            return result;
        }

        public List<TemplateConfigurationModel> GetAllTemplateConfigurations(TemplateConfigurationModel TemplateConfigurationModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllTemplateConfigurations", "Client Service"));

            LoggingManager.Debug(TemplateConfigurationModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<TemplateConfigurationModel> result = _clientRepository.GetAllTemplateConfigurations(TemplateConfigurationModel, loggedInContext, validationMessages).ToList();
            return result;
        }
        public void SendKYCRemindMail()
        {
            ClientInputModel clientInput = new ClientInputModel();

            var validationMessages = new List<ValidationMessage>();

            List<CompanyOutputModel> companies = _companyStructureRepository.SearchCompanies(new CompanySearchCriteriaInputModel() { ForSuperUser = true }, validationMessages);

            if (companies != null && companies.Count > 0)
            {
                foreach (var c in companies)
                {
                    var owner = _userRepository.GetUserDetailsByName(c.WorkEmail, true).FirstOrDefault();

                    if (owner != null)
                    {
                        LoggedInContext loggedInContext = new LoggedInContext
                        {
                            LoggedInUserId = owner.Id,
                            CompanyGuid = owner.CompanyId
                        };

                        List<ClientOutputModel> clientOutputs = GetClients(clientInput, loggedInContext, validationMessages)?.Where(x => x.KycRemindDate?.AddDays(1).ToString("dd/M/yyyy", CultureInfo.InvariantCulture) == DateTime.Now.ToString("dd/M/yyyy", CultureInfo.InvariantCulture) && x.KycRemindDate != null)?.ToList();

                        SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, null);

                        var siteDomain = ConfigurationManager.AppSettings["SiteUrl"];

                        HtmlTemplateSearchInputModel htmlTemplateSearchInputModel = new HtmlTemplateSearchInputModel()
                        {
                            IsArchived = false
                        };

                        var templates = _htmlTemplateRepository.GetHtmlTemplates(htmlTemplateSearchInputModel, loggedInContext, validationMessages);

                        if (templates != null)
                        {
                            CompanySettingsSearchInputModel companySettingMainLogoModel = new CompanySettingsSearchInputModel
                            {
                                Key = "MainLogo",
                                IsArchived = false
                            };

                            string mainLogo = (_masterDataManagementRepository.GetCompanySettings(companySettingMainLogoModel, loggedInContext, new List<ValidationMessage>())?.FirstOrDefault()?.Value);

                            var html = _goalRepository.GetHtmlTemplateByName("SendKYCRemindMail", loggedInContext.CompanyGuid);

                            foreach (var clients in clientOutputs)
                            {
                                var siteAddress = siteDomain + "/client/kycDetailsSubmission/"+clients.ClientId;

                                var htmlLatest = _goalRepository.GetHtmlTemplateByName("SendKYCRemindMail", loggedInContext.CompanyGuid);

                             string html1 = html?.Replace("##CompanyName##", smtpDetails.CompanyName).
                                        Replace("##siteUrl##", siteAddress).
                                        Replace("##CompanyLogo##", mainLogo);

                                var toMails = new string[1];

                                toMails[0] = clients.Email;

                                DateTime exeDate = Convert.ToDateTime(clients.KycRemindDate).Date;
                                TimeSpan ts = new TimeSpan(00, 00, 0);
                                exeDate = exeDate + ts;
                                int ustTime = -270;
                                int offSetMin = _userRepository.GetOffsetMinutes(clients.UserId);
                                if (offSetMin != 0)
                                    exeDate = exeDate.AddDays(1).AddMinutes(ustTime).AddMinutes(offSetMin);
                                else
                                    exeDate = exeDate.AddDays(1);

                                EmailGenericModel emailModel = new EmailGenericModel
                                {
                                    SmtpServer = smtpDetails?.SmtpServer,
                                    SmtpServerPort = smtpDetails?.SmtpServerPort,
                                    SmtpMail = smtpDetails?.SmtpMail,
                                    SmtpPassword = smtpDetails?.SmtpPassword,
                                    ToAddresses = toMails,
                                    HtmlContent = html1,
                                    Subject = "kyc Renewal",
                                    CCMails = null,
                                    BCCMails = null,
                                    MailAttachments = null,
                                    IsPdf = null
                                };
                                //_emailService.SendMail(loggedInContext, emailModel);
                                var jobId = BackgroundJob.Schedule(() => _emailService.SendMail(loggedInContext, emailModel), exeDate);
                                
                            }
                        }

                    }

                }
            }


        }

        public Guid? UpsertEmailTemplate(EmailTemplateModel EmailTemplateModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertEmailTemplate", "Client Service"));

            LoggingManager.Debug(EmailTemplateModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            Guid? result = _clientRepository.UpsertEmailTemplate(EmailTemplateModel, loggedInContext, validationMessages);
            return result;
        }

        public virtual List<EmailTemplateModel> GetAllEmailTemplates(EmailTemplateModel EmailTemplateModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllEmailTemplates", "Client Service"));

            LoggingManager.Debug(EmailTemplateModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<EmailTemplateModel> result = _clientRepository.GetAllEmailTemplates(EmailTemplateModel, loggedInContext, validationMessages).ToList();
            return result;
        }        
        
        public List<EmailTemplateModel> GetHtmlTagsById(EmailTemplateModel EmailTemplateModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllEmailTemplates", "Client Service"));

            LoggingManager.Debug(EmailTemplateModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<EmailTemplateModel> result = _clientRepository.GetHtmlTagsById(EmailTemplateModel, loggedInContext, validationMessages).ToList();
            return result;
        }

        public Guid? UpsertContractStatus(ContractStatusModel ContractStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertKycStatus", "Client Service"));

            LoggingManager.Debug(ContractStatusModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            Guid? result = _clientRepository.UpsertContractStatus(ContractStatusModel, loggedInContext, validationMessages);
            return result;
        }

        public List<ContractStatusModel> GetAllContractStatus(ContractStatusModel ContractStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllLegalEntities", "Client Service"));

            LoggingManager.Debug(ContractStatusModel.ToString());

            
            List<ContractStatusModel> result = _clientRepository.GetAllContractStatus(ContractStatusModel, loggedInContext, validationMessages).ToList();
            return result;
        }

        public Guid? UpsertInvoiceStatus(ClientInvoiceStatus ClientInvoiceStatus, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertKycStatus", "Client Service"));

            LoggingManager.Debug(ClientInvoiceStatus.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            Guid? result = _clientRepository.UpsertInvoiceStatus(ClientInvoiceStatus, loggedInContext, validationMessages);
            return result;
        }

        public List<ClientInvoiceStatus> GetAllInvoiceStatus(ClientInvoiceStatus ClientInvoiceStatus, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllLegalEntities", "Client Service"));

            LoggingManager.Debug(ClientInvoiceStatus.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<ClientInvoiceStatus> result = _clientRepository.GetAllInvoiceStatus(ClientInvoiceStatus, loggedInContext, validationMessages).ToList();
            return result;
        }
        public virtual List<ClientInvoiceStatus> GetAllInvoicePaymentStatus(ClientInvoiceStatus ClientInvoiceStatus, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllInvoicePaymentStatus", "Client Service"));

            LoggingManager.Debug(ClientInvoiceStatus.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<ClientInvoiceStatus> result = _clientRepository.GetAllInvoicePaymentStatus(ClientInvoiceStatus, loggedInContext, validationMessages).ToList();
            return result;
        }

        public List<TradeContractTypesModel> GetTradeContractTypes(TradeContractTypesModel TradeContractTypesModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTradeContractTypes", "Client Service"));

            LoggingManager.Debug(TradeContractTypesModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<TradeContractTypesModel> result = _clientRepository.GetTradeContractTypes(TradeContractTypesModel, loggedInContext, validationMessages).ToList();
            return result;
        }

    }
}