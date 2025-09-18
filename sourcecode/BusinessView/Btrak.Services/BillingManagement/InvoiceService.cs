using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.BillingManagement;
using BTrak.Common;
using System;
using System.Collections.Generic;
using Btrak.Services.Audit;
using Btrak.Services.Helpers.BillingManagement;
using Btrak.Services.Helpers;
using System.Threading.Tasks;
using System.IO;
using Btrak.Services.Chromium;
using Btrak.Services.CompanyStructure;
using Btrak.Models.CompanyStructure;
using Microsoft.WindowsAzure.Storage.Blob;
using Microsoft.WindowsAzure.Storage;
using Microsoft.Azure;
using System.Text.RegularExpressions;
using static BTrak.Common.Enumerators;
using Btrak.Models.SystemManagement;
using System.Web;
using Hangfire;
using Btrak.Services.Email;
using Btrak.Dapper.Dal.Partial;
using Btrak.Models.MasterData;
using System.Linq;

namespace Btrak.Services.BillingManagement
{
    public class InvoiceService : IInvoiceService
    {

        private readonly BillingInvoiceRepository _billingInvoiceRepository;
        private readonly IAuditService _auditService;
        private readonly IChromiumService _chromiumService;
        private readonly ICompanyStructureService _companyStructureService;
        private readonly GoalRepository _goalRepository = new GoalRepository();
        private readonly UserRepository _userRepository = new UserRepository();
        private readonly MasterDataManagementRepository _masterDataManagementRepository = new MasterDataManagementRepository();
        private readonly IEmailService _emailService;

        public InvoiceService(BillingInvoiceRepository billingInvoiceRepository, IAuditService auditService, IChromiumService chromiumService, ICompanyStructureService companyStructureService, IEmailService emailService)
        {
            _billingInvoiceRepository = billingInvoiceRepository;
            _auditService = auditService;
            _chromiumService = chromiumService;
            _companyStructureService = companyStructureService;
            _emailService = emailService;
        }

        public Guid? UpsertInvoice(UpsertInvoiceInputModel upsertInvoiceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertInvoice", "Invoice Service"));

            if (!InvoiceValidations.ValidateUpsertInvoice(upsertInvoiceInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            if (upsertInvoiceInputModel.InvoiceTasks != null)
            {
                upsertInvoiceInputModel.InvoiceTasksXml = Utilities.ConvertIntoListXml(upsertInvoiceInputModel.InvoiceTasks);
            }

            if (upsertInvoiceInputModel.InvoiceItems != null)
            {
                upsertInvoiceInputModel.InvoiceItemsXml = Utilities.ConvertIntoListXml(upsertInvoiceInputModel.InvoiceItems);
            }

            if (upsertInvoiceInputModel.InvoiceGoals != null)
            {
                upsertInvoiceInputModel.InvoiceGoalsXml = Utilities.ConvertIntoListXml(upsertInvoiceInputModel.InvoiceGoals);
            }

            if (upsertInvoiceInputModel.InvoiceProjects != null)
            {
                upsertInvoiceInputModel.InvoiceProjectsXml = Utilities.ConvertIntoListXml(upsertInvoiceInputModel.InvoiceProjects);
            }

            if (upsertInvoiceInputModel.InvoiceTax != null)
            {
                upsertInvoiceInputModel.InvoiceTaxXml = Utilities.ConvertIntoListXml(upsertInvoiceInputModel.InvoiceTax);
            }

            upsertInvoiceInputModel.InvoiceId = _billingInvoiceRepository.UpsertInvoice(upsertInvoiceInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertInvoiceCommandId, upsertInvoiceInputModel, loggedInContext);

            LoggingManager.Debug(upsertInvoiceInputModel.InvoiceId?.ToString());

            return upsertInvoiceInputModel.InvoiceId;
        }

        public List<InvoiceOutputModel> GetInvoices(InvoiceInputModel invoiceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllInvoices", "Invoice Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllInvoices", "Invoice Service"));

            List<InvoiceOutputModel> invoiceList = _billingInvoiceRepository.GetInvoices(invoiceInputModel, loggedInContext, validationMessages);

            if (invoiceList.Count > 0)
            {
                foreach (var invoice in invoiceList)
                {
                    if (invoice.InvoiceTasksXml != null)
                    {
                        invoice.InvoiceTasks = Utilities.GetObjectFromXml<InvoiceTasksInputModel>(invoice.InvoiceTasksXml, "InvoiceTasksInputModel");
                    }
                    else
                    {
                        invoice.InvoiceTasks = new List<InvoiceTasksInputModel>();
                    }

                    if (invoice.InvoiceItemsXml != null)
                    {
                        invoice.InvoiceItems = Utilities.GetObjectFromXml<InvoiceItemsInputModel>(invoice.InvoiceItemsXml, "InvoiceItemsInputModel");
                    }
                    else
                    {
                        invoice.InvoiceItems = new List<InvoiceItemsInputModel>();
                    }
                }
            }

            _auditService.SaveAudit(AppCommandConstants.GetInvoiceCommandId, invoiceInputModel, loggedInContext);

            return invoiceList;
        }

        public List<InvoiceStatusModel> GetInvoiceStatuses(InvoiceStatusModel invoiceStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetInvoiceStatuses", "Invoice Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInvoiceStatuses", "Invoice Service"));

            List<InvoiceStatusModel> invoiceStatusList = _billingInvoiceRepository.GetInvoiceStatuses(invoiceStatusModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.GetInvoiceCommandId, invoiceStatusModel, loggedInContext);

            return invoiceStatusList;
        }

        public List<InvoiceHistoryModel> GetInvoiceHistory(InvoiceHistoryModel invoiceHistoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetInvoiceHistory", "Invoice Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInvoiceHistory", "Invoice Service"));

            List<InvoiceHistoryModel> invoiceHistoryList = _billingInvoiceRepository.GetInvoiceHistory(invoiceHistoryModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.GetInvoiceCommandId, invoiceHistoryModel, loggedInContext);

            return invoiceHistoryList;
        }

        public List<AccountTypeModel> GetAccountTypes(AccountTypeModel accountTypeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAccountTypes", "Invoice Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAccountTypes", "Invoice Service"));

            List<AccountTypeModel> accountTypeList = _billingInvoiceRepository.GetAccountTypes(accountTypeModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.GetInvoiceCommandId, accountTypeModel, loggedInContext);

            return accountTypeList;
        }

        public Guid? InsertInvoiceLogPayment(InvoicePaymentLogModel invoicePaymentLogModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "InsertInvoiceLogPayment", "Invoice Service"));

            if (!InvoiceValidations.ValidateInsertInvoiceLogPayment(invoicePaymentLogModel, loggedInContext, validationMessages))
            {
                return null;
            }

            invoicePaymentLogModel.InvoicePaymentLogId = _billingInvoiceRepository.InsertInvoiceLogPayment(invoicePaymentLogModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertInvoiceCommandId, invoicePaymentLogModel, loggedInContext);

            LoggingManager.Debug(invoicePaymentLogModel.InvoicePaymentLogId?.ToString());

            return invoicePaymentLogModel.InvoicePaymentLogId;
        }

        public async Task<string> DownloadOrSendPdfInvoice(InvoiceOutputModel invoiceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DownloadOrSendPdfInvoice", "Invoice Service"));
            {
                var containTitle = false;
                var containPo = false;
                var containDueDate = false;
                var containTasks = false;
                var containItems = false;
                var containTerms = false;
                var containNotes = false;

                if(!string.IsNullOrEmpty(invoiceInputModel.Title))
                {
                    containTitle = true;
                }
                if (!string.IsNullOrEmpty(invoiceInputModel.PO))
                {
                    containPo = true;
                }
                if (invoiceInputModel.DueDate != null)
                {
                    containDueDate = true;
                }
                if (invoiceInputModel.InvoiceTasks != null && invoiceInputModel.InvoiceTasks.Count > 0)
                {
                    containTasks = true;
                }
                if (invoiceInputModel.InvoiceItems != null && invoiceInputModel.InvoiceItems.Count > 0)
                {
                    containItems = true;
                }
                if (!string.IsNullOrEmpty(invoiceInputModel.Terms))
                {
                    containTerms = true;
                }
                if (!string.IsNullOrEmpty(invoiceInputModel.Notes))
                {
                    containNotes = true;
                }

                string invoicePdfView = "<div class=\"invoice-container\"><div><h6><b>"+LangTextResolver.BillTo+"</b></h6><div class=\"fxLayout-row\"><div class=\"fxFlex50-start d-block word-break\">" + invoiceInputModel.ClientName + "</div></div></div>";
                invoicePdfView += "<hr><div><div class=\"fxLayout-row\"><div class=\"fxFlex50-column-start mb-1\">";
                
                if(containTitle)
                {
                    invoicePdfView += "<div class=\"fxFlex100 mt-02 invoice-page invoice-amount-price word-break\">" + invoiceInputModel.Title + "</div>";
                }

                invoicePdfView += "<div class=\"mt-02 fxFlex100\"><span><b>"+ LangTextResolver.Invoice + " #: </b></span>" + invoiceInputModel.InvoiceNumber + "</div>";

                if (containPo)
                {
                    invoicePdfView += "<div class=\"fxFlex100\"><span><b>PO #: </b></span>" + invoiceInputModel.PO + "</div>";
                }

                invoicePdfView += "<div class=\"fxFlex100\">" + invoiceInputModel.IssueDate?.ToString("MMMM dd, yyyy") + "</div></div>" +
                    "<div class=\"fxFlex50-column-end\"><div class=\"fxFlex100-end mt-02\"><span class=\"invoice-amount-price\" style=\"text-align: right;\">" + invoiceInputModel.CurrencyCode + "" + invoiceInputModel.Symbol + invoiceInputModel.TotalInvoiceAmount.ToString("n2") + "</span></div>";

                if(containDueDate)
                {
                    invoicePdfView += "<div class=\"fxFlex100-end mt-02\"><span class=\"mr-05\"><b>"+ LangTextResolver.DueDate +": </b></span>" + invoiceInputModel.DueDate?.ToString("MMMM dd, yyyy") + "</div>";
                }

                invoicePdfView += "</div></div></div></div>";

                if (containTasks)
                {
                    invoicePdfView += "<div class=\"invoice-container\"><div class=\"table-responsive overflow-visible\"><table class=\"table mb-0\">" +
                        "<thead><tr><th>"+ LangTextResolver.Task + "</th><th>"+ LangTextResolver.Rate + "</th><th>"+LangTextResolver.Hours + "</th><th>"+ LangTextResolver.Total + "</th></tr></thead><tbody>";
                    foreach (var task in invoiceInputModel.InvoiceTasks)
                    {
                        invoicePdfView += "<tr><td><div class=\"fxLayout-row word-break\">" + task.TaskName + "</div>";
                        if (!string.IsNullOrEmpty(task.TaskDescription))
                        {
                            invoicePdfView += "<div class=\"fxLayout-row mt-05 word-break\">" + task.TaskDescription + "</div>";
                        }
                        invoicePdfView += "</td><td>" + task.Rate.ToString("n2") + "</td><td>" + task.Hours + "</td><td><label>" + invoiceInputModel.Symbol + "" + task.Total.ToString("n2") + "</label></td></tr>";
                    }
                    invoicePdfView += "</tbody></table></div></div>";
                }

                if(containItems)
                {
                    invoicePdfView += "<div class=\"invoice-container\"><div class=\"table-responsive overflow-visible\"><table class=\"table mb-0\">" +
                        "<thead><tr><th>"+ LangTextResolver.Item + "</th><th>"+ LangTextResolver.Price + "</th><th>"+ LangTextResolver.Quantity + "</th><th>"+ LangTextResolver.Total + "</th></tr></thead><tbody>";
                    foreach (var item in invoiceInputModel.InvoiceItems)
                    {
                        invoicePdfView += "<tr><td><div class=\"fxLayout-row word-break\">" + item.ItemName + "</div>";
                        if (!string.IsNullOrEmpty(item.ItemDescription))
                        {
                            invoicePdfView += "<div class=\"fxLayout-row mt-05 word-break\">" + item.ItemDescription + "</div>";
                        }
                        invoicePdfView += "</td><td>" + item.Price.ToString("n2") + "</td><td>" + item.Quantity + "</td><td><label>" + invoiceInputModel.Symbol + "" + item.Total.ToString("n2") + "</label></td></tr>";
                    }
                    invoicePdfView += "</tbody></table></div></div>";
                }

                invoicePdfView += "<div class=\"fxLayout-row mt-1-05 invoice-container\"><div class=\"fxFlex48\">";

                if (containTerms)
                {
                    invoicePdfView += "<div><span class=\"mb-0\"><b>"+ LangTextResolver.Terms + "</b></span><div class=\"word-break\">" + invoiceInputModel.Terms + "</div></div>";
                }

                if (containNotes)
                {
                    invoicePdfView += "<div class=\"mt-05\"><span class=\"mb-0\"><b>"+ LangTextResolver.Notes + "</b></span><div class=\"word-break\">" + invoiceInputModel.Notes + "</div></div>";
                }

                invoicePdfView += "</div><div class=\"fxFlex div-page-break\"><div class=\"fxLayout-row ml-1\"><div class=\"fxFlex49-column\"><span><b>"+ LangTextResolver.SubTotal+":</b></span><span>"+ LangTextResolver.Discount +": (" + invoiceInputModel.Discount.ToString("n2") + "%)</span></div>" +
                    "<div class=\"fxFlex49-column\"><span class=\"fxLayout-end\"><b>" + invoiceInputModel.Symbol + "" + invoiceInputModel.SubTotalInvoiceAmount.ToString("n2") + "</b></span><span class=\"fxLayout-end\">(" +
                    invoiceInputModel.Symbol + "" + invoiceInputModel.InvoiceDiscountAmount.ToString("n2") + ")</span></div></div><hr class=\"ml-1\"><div class=\"fxLayout-row mt-05 ml-1\"><div class=\"fxFlex49-column\">" +
                    "<span><b>"+ LangTextResolver.Total +":</b></span><span>"+ LangTextResolver.Paid +":</span></div><div class=\"fxFlex49-column\"><span class=\"fxLayout-end\"><b>" + invoiceInputModel.Symbol + "" + invoiceInputModel.TotalInvoiceAmount.ToString("n2") + "" +
                    "</b></span><span class=\"fxLayout-end\">" + invoiceInputModel.Symbol + "" + invoiceInputModel.AmountPaid.ToString("n2") + "" + "</span></div></div><hr class=\"ml-1\"><div class=\"fxLayout-row mt-05 ml-1 mb-1\"><div class=\"fxFlex49-column\"><span><b>"+ LangTextResolver.AmountDue+":</b></span></div>" +
                    "<div class=\"fxFlex49-column\"><span class=\"fxLayout-end\"><b>" + invoiceInputModel.Symbol + "" + invoiceInputModel.DueAmount.ToString("n2") + "</b></span></div>" +
                    "</div></div></div>";

                var html = _goalRepository.GetHtmlTemplateByName("InvoicePDFTemplate", loggedInContext.CompanyGuid).Replace("##invoicePDFJson##", invoicePdfView);

                var pdfOutput = await _chromiumService.GeneratePdf(html, null, invoiceInputModel.InvoiceNumber);

                CompanyOutputModel companyModel = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

                var companySettingsSearchInputModel = new CompanySettingsSearchInputModel();
                companySettingsSearchInputModel.CompanyId = companyModel ?.CompanyId;
                companySettingsSearchInputModel.IsSystemApp = null;
                string storageAccountName = string.Empty;

                List<CompanySettingsSearchOutputModel> companySettings = _masterDataManagementRepository.GetCompanySettings(companySettingsSearchInputModel, loggedInContext, validationMessages).ToList();
                if(companySettings.Count > 0)
                {
                    var storageAccountDetails = companySettings.Where(x => x.Key == "StorageAccountName").FirstOrDefault();
                    storageAccountName = storageAccountDetails?.Value;
                }

                var directory = SetupCompanyFileContainer(companyModel, 6, loggedInContext.LoggedInUserId, storageAccountName);

                var fileName = invoiceInputModel.InvoiceNumber;

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

                if (!invoiceInputModel.IsForMail)
                {
                    return fileurl;
                }
                else
                {
                    SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, HttpContext.Current.Request.Url.Authority);

                    Stream stream = new MemoryStream(pdfOutput.ByteStream);

                    List<Stream> fileStream = new List<Stream>();

                    fileStream.Add(stream);

                    var toEmails = (invoiceInputModel.TO == null || invoiceInputModel.TO.Trim() == "") ? null : invoiceInputModel.TO.Trim().Split('\n');
                    var ccEmails = (invoiceInputModel.CC == null || invoiceInputModel.CC.Trim() == "") ? null : invoiceInputModel.CC.Trim().Split('\n');
                    var bccEmails = (invoiceInputModel.BCC == null || invoiceInputModel.BCC.Trim() == "") ? null : invoiceInputModel.BCC.Trim().Split('\n');

                    var pdfHtml = _goalRepository.GetHtmlTemplateByName("InvoiceMailTemplate", loggedInContext.CompanyGuid).Replace("##ToName##", invoiceInputModel.ClientName).Replace("##PdfUrl##", fileurl);

                    //BackgroundJob.Enqueue(() => _emailService.SendMail(loggedInContext, smtpDetails.SmtpMail, smtpDetails.SmtpPassword,
                    //    toEmails, pdfHtml, "Snovasys Business Suite: Invoice Mail Template", ccEmails, bccEmails,
                    //    fileStream, true));

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
                            Subject = "Invoice Mail Template",
                            CCMails = ccEmails,
                            BCCMails = bccEmails,
                            MailAttachments = fileStream,
                            IsPdf = true
                        };
                        _emailService.SendMail(loggedInContext, emailModel);
                    });

                    return fileurl;
                }
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
            } else
            {
                account = storageAccountName;
            }
           
            string key = CloudConfigurationManager.GetSetting("StorageAccountAccessKey");
            string connectionString = $"DefaultEndpointsProtocol=https;AccountName={account};AccountKey={key}";
            CloudStorageAccount storageAccount = CloudStorageAccount.Parse(connectionString);

            LoggingManager.Debug("Exit from GetStorageAccount method of blob service");

            return storageAccount;
        }

        public List<InvoiceGoalOutputModel> GetInvoiceGoals(InvoiceGoalInputModel invoiceGoalInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllInvoiceGoals", "Invoice Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllInvoiceGoals", "Invoice Service"));

            List<InvoiceGoalOutputModel> invoiceGoalsList = _billingInvoiceRepository.GetInvoiceGoals(invoiceGoalInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.GetInvoiceGoalsCommandId, invoiceGoalInputModel, loggedInContext);

            return invoiceGoalsList;
        }

        public List<InvoiceTasksOutputModel> GetInvoiceTasks(InvoiceTasksInputModel invoiceTasksInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllInvoiceTasks", "Invoice Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllInvoiceTasks", "Invoice Service"));

            List<InvoiceTasksOutputModel> invoiceTasksList = _billingInvoiceRepository.GetInvoiceTasks(invoiceTasksInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.GetInvoiceTasksCommandId, invoiceTasksInputModel, loggedInContext);

            return invoiceTasksList;
        }

        public List<InvoiceItemsOutputModel> GetInvoiceItems(InvoiceItemsInputModel invoiceItemsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllInvoiceItems", "Invoice Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllInvoiceItems", "Invoice Service"));

            List<InvoiceItemsOutputModel> invoiceItemsList = _billingInvoiceRepository.GetInvoiceItems(invoiceItemsInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.GetInvoiceItemsCommandId, invoiceItemsInputModel, loggedInContext);

            return invoiceItemsList;
        }

        public List<InvoiceProjectsOutputModel> GetInvoiceProjects(InvoiceProjectsInputModel invoiceProjectsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllInvoiceProjects", "Invoice Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllInvoiceProjects", "Invoice Service"));

            List<InvoiceProjectsOutputModel> invoiceProjectsList = _billingInvoiceRepository.GetInvoiceProjects(invoiceProjectsInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.GetInvoiceProjectsCommandId, invoiceProjectsInputModel, loggedInContext);

            return invoiceProjectsList;
        }

        public List<InvoiceTaxOutputModel> GetInvoiceTax(InvoiceTaxInputModel invoiceTaxInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetInvoiceTax", "Invoice Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInvoiceTax", "Invoice Service"));

            List<InvoiceTaxOutputModel> invoiceTax = _billingInvoiceRepository.GetInvoiceTax(invoiceTaxInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.GetInvoiceTaxCommandId, invoiceTaxInputModel, loggedInContext);

            return invoiceTax;
        }

        public List<Guid?> MultipleInvoiceDelete(MultipleInvoiceDeleteModel multipleInvoiceDeleteModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetInvoices", "InvoiceInputModel", multipleInvoiceDeleteModel, "Invoice Service"));

            if (multipleInvoiceDeleteModel.InvoiceId != null)
            {
                multipleInvoiceDeleteModel.InvoiceIdXml = Utilities.ConvertIntoListXml(multipleInvoiceDeleteModel.InvoiceId.ToArray());
            }

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.MultipleInvoiceDeleteId, multipleInvoiceDeleteModel, loggedInContext);

            List<Guid?> invoiceId = _billingInvoiceRepository.MultipleInvoiceDelete(multipleInvoiceDeleteModel, loggedInContext, validationMessages);

            return invoiceId;
        }

        //public bool? SendInvoiceEmail(Guid? invoiceId, List<ValidationMessage> validationMessages)
        //{
        //    LoggingManager.Debug("Invoice is not found with invoice id " + invoiceId);


        //    SendInvoiceEmailModel sendInvoiceEmailModel = _billingInvoiceRepository.SendInvoiceEmail(invoiceId, validationMessages);
        //    if (sendInvoiceEmailModel == null)
        //    {
        //        validationMessages.Add(new ValidationMessage
        //        {
        //            ValidationMessageType = MessageTypeEnum.Error,

        //        });
        //        return null;
        //    }


        //    SendInvoiceEmailTemplateModel emailModel = sendinvoicemail(sendInvoiceEmailModel);

        //    LoggingManager.Debug("Invoice  has been sent to respective mail id.");

        //    emailModel?.Send();

        //    return true;
        //}

        //private static void sendinvoicemail(SendInvoiceEmailModel model)
        //{
        //    LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "sendinvoicemail", "invoicemanagement service"));

        //    if (model?.InvoiceId != null)
        //    {
        //        SendInvoiceEmailTemplateModel email = new SendInvoiceEmailTemplateModel("sendinvoicetemplate")
        //        {
        //            To = model.SendTo,
        //            Cc = model.CC,
        //            Bcc = model.BCC,
        //            SendInvoiceEmailModel = model
        //        };

        //        return null;
        //    }
        //    LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "sendinvoicemail", "invoicemanagement service"));
        //    return null;
        //}

        //public List<GetClientInvoiceOutputModel> GetClientInvoice(ClientInvoiceSearchInputModel getClientInvoiceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        //{
        //    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetClientInvoice", "GetInvoiceInputModel", getClientInvoiceInputModel, "InvoiceManagement Service"));

        //    if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
        //    {
        //        return null;
        //    }

        //    _auditService.SaveAudit(AppCommandConstants.GetClientInvoiceId, getClientInvoiceInputModel, loggedInContext);

        //    List<GetClientInvoiceOutputModel> clientInvoiceLists = _invoiceManagementRepository.GetClientInvoice(getClientInvoiceInputModel, loggedInContext, validationMessages);

        //    return clientInvoiceLists;
        //}

        //public List<GetClientProjectOutputModel> GetClientProjects(ClientProjectSearchInputModel getClientProjectInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        //{
        //    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetClientProjects", "GetClientProjectInputModel", getClientProjectInputModel, "InvoiceManagement Service"));

        //    if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
        //    {
        //        return null;
        //    }

        //    _auditService.SaveAudit(AppCommandConstants.GetClientProjectsId, getClientProjectInputModel, loggedInContext);

        //    List<GetClientProjectOutputModel> clientProjectLists = _invoiceManagementRepository.GetClientProjects(getClientProjectInputModel, loggedInContext, validationMessages);

        //    return clientProjectLists;
        //}

        //public List<GetInvoiceStatusOutputModel> GetInvoiceStatus(string searchText, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        //{
        //    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetInvoiceStatus", "searchText", searchText, "InvoiceManagement Service"));

        //    if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
        //    {
        //        return null;
        //    }

        //    _auditService.SaveAudit(AppCommandConstants.GetInvoiceStatusId, searchText, loggedInContext);

        //    List<GetInvoiceStatusOutputModel> invoiceStatusLists = _invoiceManagementRepository.GetInvoiceStatus(searchText, loggedInContext, validationMessages);

        //    return invoiceStatusLists;

        //}

    }
}