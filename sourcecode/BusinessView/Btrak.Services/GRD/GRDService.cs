using Btrak.Dapper.Dal.Partial;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.CompanyStructure;
using Btrak.Models.GRD;
using Btrak.Models.MasterData;
using Btrak.Models.Site;
using Btrak.Models.SystemManagement;
using Btrak.Services.Audit;
using Btrak.Services.Chromium;
using Btrak.Services.CompanyStructure;
using Btrak.Services.Email;
using Btrak.Services.Helpers.GRD;
using BTrak.Common;
using Hangfire;
using Microsoft.Azure;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web;
using static BTrak.Common.Enumerators;

namespace Btrak.Services.GRD
{
    public class GRDService : IGRDService
    {
        private readonly GRDRepository _gRDRepository;
        private readonly IAuditService _auditService;
        private readonly UserRepository _userRepository;
        private readonly GoalRepository _goalRepository;
        private readonly IEmailService _emailService;
        private readonly ICompanyStructureService _companyStructureService;
        private readonly MasterDataManagementRepository _masterDataManagementRepository;
        private readonly IChromiumService _chromiumService;
        private readonly SiteRepository _siteRepository;

        public GRDService(GRDRepository gRDRepository, CompanyStructureService companyStructureService, MasterDataManagementRepository masterDataManagementRepository, GoalRepository goalRepository, UserRepository userRepository, SiteRepository siteRepository, IEmailService emailService, IChromiumService chromiumService, IAuditService auditService)
        {
            _gRDRepository = gRDRepository;
            _auditService = auditService;
            _siteRepository = siteRepository;
            _companyStructureService = companyStructureService;
            _masterDataManagementRepository = masterDataManagementRepository;
            _emailService = emailService;
            _userRepository = userRepository;
            _goalRepository = goalRepository;
            _chromiumService = chromiumService;
        }

        public Guid? UpsertGRD(GRDInputModel grdInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertGRD", "grdInputModel", grdInputModel, "GRD Service"));

            if (!GRDValidationHelper.UpsertGRDValidation(grdInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            grdInputModel.Id = _gRDRepository.UpsertGRD(grdInputModel, loggedInContext, validationMessages);

            LoggingManager.Debug(grdInputModel.Id?.ToString());

            _auditService.SaveAudit(AppCommandConstants.UpsertGRDCommandId, grdInputModel, loggedInContext);

            return grdInputModel.Id;
        }

        public List<GRDSearchOutputModel> GetGRD(GRDSearchInputModel grdInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GeyGRD", "grdInput", grdInput, "GRD Service"));

            _auditService.SaveAudit(AppCommandConstants.GetGRDCommandId, grdInput, loggedInContext);

            List<GRDSearchOutputModel> grdList = _gRDRepository.GetGRD(grdInput, loggedInContext, validationMessages);

            return grdList;
        }
        public async Task<Guid?> UpsertCreditNote(CreditNoteUpsertInputModel creditNoteUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCreditNote", "creditNoteUpsertInputModel", creditNoteUpsertInputModel, "GRD Service"));

            if (!GRDValidationHelper.UpsertCreditNoteValidation(creditNoteUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            if (creditNoteUpsertInputModel.IsGenerateInvoice == true && creditNoteUpsertInputModel.IsArchived != false)
            {
                creditNoteUpsertInputModel.Id = await GenerateofCreditNote(creditNoteUpsertInputModel, loggedInContext, validationMessages);
            }
            else
            {
                creditNoteUpsertInputModel.Id = _gRDRepository.UpsertCreditNote(creditNoteUpsertInputModel, loggedInContext, validationMessages);
            }
            LoggingManager.Debug(creditNoteUpsertInputModel.Id?.ToString());

            _auditService.SaveAudit(AppCommandConstants.UpsertCreditNoteCommandId, creditNoteUpsertInputModel, loggedInContext);

            return creditNoteUpsertInputModel.Id;
        }

        public List<CreditNoteSearchOutputModel> GetCreditNote(CreditNoteSearchInputModel creditNoteSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetCreditNote", "grdInput", creditNoteSearchInputModel, "GRD Service"));

            _auditService.SaveAudit(AppCommandConstants.GetCreditNoteCommandId, creditNoteSearchInputModel, loggedInContext);

            List<CreditNoteSearchOutputModel> creditNotes = _gRDRepository.GetCreditNote(creditNoteSearchInputModel, loggedInContext, validationMessages);

            return creditNotes;
        }
        public Guid? UpsertMasterAccount(MasterAccountUpsertInputModel masterAccountUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertMasterAccount", "masterAccountUpsertInputModel", masterAccountUpsertInputModel, "GRD Service"));

            if (!GRDValidationHelper.UpsertMasterAccountValidation(masterAccountUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            masterAccountUpsertInputModel.Id = _gRDRepository.UpsertMasterAccount(masterAccountUpsertInputModel, loggedInContext, validationMessages);

            LoggingManager.Debug(masterAccountUpsertInputModel.Id?.ToString());

            _auditService.SaveAudit(AppCommandConstants.UpsertMasterAccountCommandId, masterAccountUpsertInputModel, loggedInContext);

            return masterAccountUpsertInputModel.Id;
        }

        public List<MasterAccountSearchOutputModel> GetMasterAccounts(MasterAccountSearchInputModel masterAccountSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetMasterAccounts", "masterAccountSearchInputModel", masterAccountSearchInputModel, "GRD Service"));

            _auditService.SaveAudit(AppCommandConstants.GetMasterAccountsCommandId, masterAccountSearchInputModel, loggedInContext);

            List<MasterAccountSearchOutputModel> masterAccounts = _gRDRepository.GetMasterAccounts(masterAccountSearchInputModel, loggedInContext, validationMessages);

            return masterAccounts;
        }
        public Guid? UpsertExpenseBooking(ExpenseBookingUpsertInputModel expenseBookingUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertExpenseBooking", "expenseBookingUpsertInputModel", expenseBookingUpsertInputModel, "GRD Service"));

            if (!GRDValidationHelper.UpsertExpenseBookingValidation(expenseBookingUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            expenseBookingUpsertInputModel.Id = _gRDRepository.UpsertExpenseBooking(expenseBookingUpsertInputModel, loggedInContext, validationMessages);

            LoggingManager.Debug(expenseBookingUpsertInputModel.Id?.ToString());

            _auditService.SaveAudit(AppCommandConstants.UpsertExpenseBookingCommandId, expenseBookingUpsertInputModel, loggedInContext);

            return expenseBookingUpsertInputModel.Id;
        }

        public List<ExpenseBookingSearchOutputModel> GetExpenseBookings(ExpenseBookingSearchInputModel expenseBookingSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetExpenseBookings", "expenseBookingSearchInputModel", expenseBookingSearchInputModel, "GRD Service"));

            _auditService.SaveAudit(AppCommandConstants.GetExpenseBookingsCommandId, expenseBookingSearchInputModel, loggedInContext);

            List<ExpenseBookingSearchOutputModel> expenseBookings = _gRDRepository.GetExpenseBookings(expenseBookingSearchInputModel, loggedInContext, validationMessages);

            return expenseBookings;
        }
        public Guid? UpsertPaymentReceipt(PaymentReceiptUpsertInputModel paymentReceiptUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertPaymentReceipt", "paymentReceiptUpsertInputModel", paymentReceiptUpsertInputModel, "GRD Service"));

            if (!GRDValidationHelper.UpsertPaymentReceiptValidation(paymentReceiptUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            paymentReceiptUpsertInputModel.Id = _gRDRepository.UpsertPaymentReceipt(paymentReceiptUpsertInputModel, loggedInContext, validationMessages);

            LoggingManager.Debug(paymentReceiptUpsertInputModel.Id?.ToString());

            _auditService.SaveAudit(AppCommandConstants.UpsertPaymentReceiptCommandId, paymentReceiptUpsertInputModel, loggedInContext);

            return paymentReceiptUpsertInputModel.Id;
        }

        public List<PaymentReceiptSearchOutputModel> GetPaymentReceipts(PaymentReceiptSearchInputModel paymentReceiptSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetPaymentReceipts", "expenseBookingSearchInputModel", paymentReceiptSearchInputModel, "GRD Service"));

            _auditService.SaveAudit(AppCommandConstants.GetPaymentReceiptsCommandId, paymentReceiptSearchInputModel, loggedInContext);

            List<PaymentReceiptSearchOutputModel> paymentReceipts = _gRDRepository.GetPaymentReceipts(paymentReceiptSearchInputModel, loggedInContext, validationMessages);

            return paymentReceipts;
        }
        public string SendCreditNoteMail(CreditNoteUpsertInputModel creditNoteUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var siteSearchModel = new SiteOutpuModel();
            siteSearchModel.Id = creditNoteUpsertInputModel.SiteId;
            var siteoutputModel = _siteRepository.GetSite(siteSearchModel, loggedInContext, validationMessages).FirstOrDefault();
            var webClient = new WebClient();
            byte[] fileBytes = webClient.DownloadData(creditNoteUpsertInputModel.InvoiceUrl);

            Stream stream = new MemoryStream(fileBytes);
            List<StreamWithType> fileStream = new List<StreamWithType>();
            fileStream.Add(new StreamWithType() { FileStream = stream, FileName = "NC-"+siteoutputModel.Name+"-"+creditNoteUpsertInputModel.Year.ToString("yyyy"), FileType = ".pdf", IsPdf = true });

            var toEmails = siteoutputModel.Email.Trim().Split('\n');
            var pdfHtml = "<html><head></head><body><div><p>Ce mail a été généré automatiquement, ne pas répondre SVP.</p><p>Pour toute communication: mfs.merchant.finance@gmail.com</p><br><p>Bonjour,</p><br><p>Veuillez trouver en p.j. notre note de crédit. <br><br><p>Nous restons à votre disposition pour tout complément d'information et vous remercions de votre collaboration.</p><br><pre style=\"font-size:15px; font-family:Roboto\">Meilleures salutations," +
"<br>Photon One SA" +
"<br>Nicolas Sanchez, Administrateur" +
"<br>+ 41 79 221 71 42 </pre></div></body></html>";

            var smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, new List<ValidationMessage>(), "");
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
                    Subject = "Note de crédit "+ creditNoteUpsertInputModel.Year.ToString("yyyy"),
                    MailAttachments = null,
                    MailAttachmentsWithFileType = fileStream,
                    IsPdf = true
                };
                _emailService.SendMail(loggedInContext, emailModel);
            });

            return creditNoteUpsertInputModel.InvoiceUrl;
        }
        public async Task<Guid?> GenerateofCreditNote(CreditNoteUpsertInputModel creditNoteUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "MailofCreditNote", "Invoice Service"));
            var siteSearchModel = new SiteOutpuModel();
            siteSearchModel.Id = creditNoteUpsertInputModel.SiteId;
            var siteoutputModel = _siteRepository.GetSite(siteSearchModel, loggedInContext, validationMessages).FirstOrDefault();
            var perAnnum = Math.Round((decimal)(siteoutputModel.M2*siteoutputModel.Chf), 2);
            var days = (creditNoteUpsertInputModel.EndDate - creditNoteUpsertInputModel.StartDate).Days;
            var daysInYear = DateTime.IsLeapYear(creditNoteUpsertInputModel.Year.Year)?366:365;
            var prorata = Math.Round((perAnnum * (decimal)days) / daysInYear, 2);
            var tva="";
            var tvaName="";
            decimal total = 0;
            if (creditNoteUpsertInputModel.IsTVAApplied == true)
            {
                tva = Math.Round((decimal)((siteoutputModel.TVAValue * prorata) / 100),2).ToString();
                total = Math.Round(((decimal)((siteoutputModel.TVAValue * prorata) / 100) + prorata), 2);
                tvaName = "TVA";
            }
            else
            {
                total = prorata;
            }
            decimal totalValue = Math.Round((total), 2);

            decimal totalValueResult = 0;


            decimal mRound = totalValue / Convert.ToDecimal(0.05);
            var result = (int)((mRound - (int)mRound) * 10);

            if (result < 5)
            {
                mRound = Math.Floor(mRound);
                totalValueResult = mRound * Convert.ToDecimal(0.05);
            }
            if (result >= 5)
            {
                mRound = Math.Ceiling(mRound);
                totalValueResult = mRound * Convert.ToDecimal(0.05);
            }

            decimal aroundiDifference = Math.Round(totalValueResult-total, 2);
            var html = _goalRepository.GetHtmlTemplateByName("CreditNotePDFTemplate", loggedInContext.CompanyGuid).Replace("##Address##", siteoutputModel.Address)
                                                    .Replace("##GridInvoiceDate##", creditNoteUpsertInputModel.EntryDate.ToString("dd.MM.yyyy")).Replace("##ROOFADDRESS##", siteoutputModel.RoofRentalAddress)
                                                    .Replace("##DATE##", siteoutputModel.Date?.ToString("dd.MM.yyyy")).Replace("##STARTDATE##", creditNoteUpsertInputModel.StartDate.ToString("dd.MM.yyyy"))
                                                    .Replace("##ENDDATE##", creditNoteUpsertInputModel.EndDate.ToString("dd.MM.yyyy")).Replace("##JOURS##", days.ToString())
                                                    .Replace("##M2##", string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", siteoutputModel.M2))
                                                    .Replace("##CHF/M2##", string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", siteoutputModel.Chf))
                                                    .Replace("##PERANNUM##", string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", perAnnum))
                                                    .Replace("##PRORATA##", string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", prorata))
                                                    .Replace("##TOTALCHF##", string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", prorata))
                                                    .Replace("##PARCELLENO##", siteoutputModel.ParcellNo)
                                                    .Replace("##TVANAME##", tvaName.ToString())
                                                    .Replace("##TVA##", string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", tva))
                                                    .Replace("##TITLE##","NO NC-"+ creditNoteUpsertInputModel.Year.ToString("yyyy")+ "-"+siteoutputModel.Name.ToString())
                                                    .Replace("##TotalValue##", string.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", Math.Round(totalValueResult,2)))
                                                    .Replace("##Arrondi##", aroundiDifference.ToString());
            var PerformaPdfOutput = await _chromiumService.GeneratePdf(html, null, creditNoteUpsertInputModel.Id.ToString());
            
            var pdfOutput = await _chromiumService.GeneratePdf(html, null, creditNoteUpsertInputModel.Id.ToString());
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

                var fileName = creditNoteUpsertInputModel.Id.ToString();

                LoggingManager.Debug("MailofCreditNote input fileName:" + fileName);

                fileName = fileName.Replace(" ", "_");

                var fileExtension = ".pdf";

                var convertedFileName = fileName + "-" + Guid.NewGuid() + fileExtension;

                CloudBlockBlob blockBlob = directory.GetBlockBlobReference(convertedFileName);

                blockBlob.Properties.CacheControl = "public, max-age=2592000";

                blockBlob.Properties.ContentType = "application/pdf";

                Byte[] bytes = pdfOutput.ByteStream;

                blockBlob.UploadFromByteArray(bytes, 0, bytes.Length);

                var fileurl = blockBlob.Uri.AbsoluteUri;

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "MailofCreditNote", "GRD Service"));

                LoggingManager.Debug(pdfOutput.ByteStream.ToString());

                Stream stream = new MemoryStream(pdfOutput.ByteStream);

                //var FileName = "Credit Note";

                var ConvertedFileName = "NO NC-" + creditNoteUpsertInputModel.Year.ToString("yyyy") + "-" + siteoutputModel.Name.ToString() + fileExtension;

                CloudBlockBlob BlockBlob = directory.GetBlockBlobReference(ConvertedFileName);

                BlockBlob.Properties.CacheControl = "public, max-age=2592000";

                BlockBlob.Properties.ContentType = "application/pdf";

                Byte[] PerformaBytes = PerformaPdfOutput.ByteStream;

                BlockBlob.UploadFromByteArray(PerformaBytes, 0, PerformaBytes.Length);

                Stream CreditNoteStream = new MemoryStream(PerformaPdfOutput.ByteStream);

                List<StreamWithType> fileStream = new List<StreamWithType>();
                fileStream.Add(new StreamWithType() { FileStream = CreditNoteStream, FileName = ConvertedFileName, FileType = ".pdf", IsPdf = true });

            creditNoteUpsertInputModel.TimeStamp = creditNoteUpsertInputModel.TimeStamp;
            creditNoteUpsertInputModel.InvoiceUrl = fileurl;
           Guid? Id = _gRDRepository.UpsertCreditNote(creditNoteUpsertInputModel, loggedInContext, validationMessages);
                return Id;
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
    }
}
