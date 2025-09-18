using Btrak.Dapper.Dal.Partial;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.CompanyStructure;
using Btrak.Models.MasterData;
using Btrak.Models.SystemManagement;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using Twilio;
using IO.ClickSend.ClickSend.Api;
using IO.ClickSend.Client;
using IO.ClickSend.ClickSend.Model;
using MessageResource = Twilio.Rest.Api.V2010.Account.MessageResource;

namespace Btrak.Services.Email
{
    public class EmailService : IEmailService
    {
        private readonly UserRepository _userRepository;
        private readonly MasterDataManagementRepository _masterDataManagementRepository;
        private readonly CompanyStructureRepository _companyStructureRepository;
        private string mainLogo;
        private string footerValue;
        private readonly MasterDataManagementRepository _masterManagementRepository = new MasterDataManagementRepository();

        public EmailService(UserRepository userRepository, MasterDataManagementRepository masterDataManagementRepository, CompanyStructureRepository companyStructureRepository)
        {
            _userRepository = userRepository;
            _masterDataManagementRepository = masterDataManagementRepository;
            _companyStructureRepository = companyStructureRepository;
        }

        public void SendEmailToUserWithContent(Models.Email.EmailModel emailModel)
        {
            if (emailModel == null)
            {
                throw new ArgumentNullException(nameof(emailModel));
            }

            try
            {
                SmtpClient smtp = new SmtpClient
                {
                    Host = ConfigurationManager.AppSettings["SmtpServer"],
                    Port = Int32.Parse(ConfigurationManager.AppSettings["SmtpServerPort"]),
                    EnableSsl = bool.Parse(ConfigurationManager.AppSettings["UseSsl"]),
                    DeliveryMethod = SmtpDeliveryMethod.Network,
                    UseDefaultCredentials = false,
                    Credentials = new NetworkCredential(ConfigurationManager.AppSettings["SmtpEmail"], ConfigurationManager.AppSettings["SmtpPassword"])
                };

                using (var message = new MailMessage(ConfigurationManager.AppSettings["FromMailAddress"], emailModel.ToAddress)
                {
                    Subject = "[Snovasys Business Suite] " + emailModel.Subject,
                    Body = emailModel.Body,
                    IsBodyHtml = emailModel.IsBodyHtml
                })
                {
                    smtp.Send(message);
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendEmailToUserWithContent", " EmailService", exception.Message), exception);

            }
        }

        private void SendEmail(EmailGenericModel emailGenericModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {

                CompanySearchCriteriaInputModel searchCriteriaModel = new CompanySearchCriteriaInputModel { CompanyId = loggedInContext?.CompanyGuid };
                CompanyOutputModel companyDetails = _companyStructureRepository.SearchCompanies(searchCriteriaModel, loggedInContext, validationMessages).FirstOrDefault();
                SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, companyDetails.SiteAddress);
                emailGenericModel.SmtpMail = smtpDetails?.SmtpMail;
                emailGenericModel.SmtpPassword = smtpDetails?.SmtpPassword;
                emailGenericModel.SmtpServer = smtpDetails?.SmtpServer;
                emailGenericModel.SmtpServerPort = smtpDetails?.SmtpServerPort;
                emailGenericModel.FromMailAddress = smtpDetails?.FromAddress;
                //emailGenericModel.SmtpMail = "sudharshanreddykasa232@gmail.com";
                //emailGenericModel.SmtpPassword = "qllk ylww kwll ofdo";
                //emailGenericModel.SmtpServer = "smtp.gmail.com";
                //emailGenericModel.SmtpServerPort = "587";
                //emailGenericModel.FromMailAddress = "sudharshanreddykasa232@gmail.com";
                //if (string.IsNullOrEmpty(emailGenericModel.SmtpMail) || string.IsNullOrEmpty(emailGenericModel.SmtpPassword) || string.IsNullOrEmpty(emailGenericModel.SmtpServer) || string.IsNullOrEmpty(emailGenericModel.SmtpServerPort)
                //    )
                //{
                //    emailGenericModel.SmtpMail = ConfigurationManager.AppSettings["SmtpEmail"];
                //    emailGenericModel.SmtpPassword = ConfigurationManager.AppSettings["SmtpPassword"];
                //    emailGenericModel.SmtpServer = ConfigurationManager.AppSettings["SmtpServer"];
                //    emailGenericModel.SmtpServerPort = ConfigurationManager.AppSettings["SmtpServerPort"];
                //    emailGenericModel.FromMailAddress = ConfigurationManager.AppSettings["FromMailAddress"];
                //    emailGenericModel.FromName = ConfigurationManager.AppSettings["FromName"] ?? "Snovasys Business Suite";
                //}


                SmtpClient smtp = new SmtpClient
                {
                    Host = emailGenericModel.SmtpServer,
                    Port = Int32.Parse(emailGenericModel.SmtpServerPort),
                    EnableSsl = true,
                    DeliveryMethod = SmtpDeliveryMethod.Network,
                    UseDefaultCredentials = false,
                    Credentials = new NetworkCredential(emailGenericModel.SmtpMail, emailGenericModel.SmtpPassword)
                };

                using (var message = new MailMessage()
                {
                    From = new MailAddress(emailGenericModel.FromMailAddress, emailGenericModel.FromName),
                    Subject = emailGenericModel.Subject,
                    Body = emailGenericModel.HtmlContent,
                    IsBodyHtml = true
                })
                {
                    try
                    {
                        //To mails
                        if (emailGenericModel.ToAddresses != null && emailGenericModel.ToAddresses.Length > 0)
                        {

                            foreach (var tomail in emailGenericModel.ToAddresses)
                            {
                                message.To.Add(new MailAddress(tomail));
                            }
                        }

                        //CC mails
                        if (emailGenericModel.CCMails != null && emailGenericModel.CCMails.Length > 0)
                        {
                            foreach (var ccmail in emailGenericModel.CCMails)
                            {
                                message.CC.Add(new MailAddress(ccmail));
                            }
                        }

                        //BCC mails
                        if (emailGenericModel.BCCMails != null && emailGenericModel.BCCMails.Length > 0)
                        {
                            foreach (var bccmail in emailGenericModel.BCCMails)
                            {
                                message.Bcc.Add(new MailAddress(bccmail));
                            }
                        }
                        //IsPdf
                        if (emailGenericModel.IsPdf == null)
                        {
                            emailGenericModel.IsPdf = false;
                        }

                        //Attachments
                        if (emailGenericModel.MailAttachments != null && emailGenericModel.MailAttachments.Count > 0)
                        {
                            foreach (var attment in emailGenericModel.MailAttachments)
                            {
                                if (emailGenericModel.IsPdf != null && emailGenericModel.IsPdf == true)
                                {
                                    var pdfFileName = Guid.NewGuid() + "-" + DateTime.Now.ToString("yyyy/M/dd") + ".pdf";
                                    var attachment = new System.Net.Mail.Attachment(attment, pdfFileName, MediaTypeNames.Application.Pdf);
                                    message.Attachments.Add(attachment);
                                }
                                else if (emailGenericModel.IsPdf != null && emailGenericModel.IsPdf == false)
                                {
                                    var excelFileName = Guid.NewGuid() + "-" + DateTime.Now.ToString("yyyy/M/dd") + ".xlsx";
                                    var attachment = new System.Net.Mail.Attachment(attment, excelFileName);
                                    attachment.ContentType = new ContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
                                    message.Attachments.Add(attachment);
                                }
                            }
                        }

                        if (emailGenericModel.MailAttachmentsWithFileType != null && emailGenericModel.MailAttachmentsWithFileType.Count > 0)
                        {
                            foreach (var attment in emailGenericModel.MailAttachmentsWithFileType)
                            {
                                if (attment.IsPdf != null && attment.IsPdf == true)
                                {
                                    var pdfFileName = attment.FileName.Contains(".pdf") ? attment.FileName : attment.FileName + ".pdf";
                                    var attachment = new System.Net.Mail.Attachment(attment.FileStream, pdfFileName, MediaTypeNames.Application.Pdf);
                                    message.Attachments.Add(attachment);
                                }
                                else if (attment.IsExcel != null && attment.IsExcel == true)
                                {
                                    var excelFileName = attment.FileName.Contains(".xlsx") ? attment.FileName : attment.FileName + ".xlsx";
                                    var attachment = new System.Net.Mail.Attachment(attment.FileStream, excelFileName);
                                    attachment.ContentType = new ContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
                                    message.Attachments.Add(attachment);
                                }
                                else if (attment.IsJpg != null && attment.IsJpg == true)
                                {
                                    var jpgFileName = attment.FileName.Contains(".jpg") ? attment.FileName : attment.FileName + ".jpg";
                                    var attachment = new System.Net.Mail.Attachment(attment.FileStream, jpgFileName, MediaTypeNames.Image.Jpeg);
                                    message.Attachments.Add(attachment);
                                }
                                else if (attment.IsJpeg != null && attment.IsJpeg == true)
                                {
                                    var jpegFileName = attment.FileName.Contains(".jpeg") ? attment.FileName : attment.FileName + ".jpeg";
                                    var attachment = new System.Net.Mail.Attachment(attment.FileStream, jpegFileName, MediaTypeNames.Image.Jpeg);
                                    message.Attachments.Add(attachment);
                                }
                                else if (attment.IsPng != null && attment.IsPng == true)
                                {
                                    var pngFileName = attment.FileName.Contains(".png") ? attment.FileName : attment.FileName + ".png";
                                    var attachment = new System.Net.Mail.Attachment(attment.FileStream, pngFileName);
                                    attachment.ContentType = new ContentType("image/png");
                                    message.Attachments.Add(attachment);
                                }
                                else if (attment.IsDocx != null && attment.IsDocx == true)
                                {
                                    var docxFileName = attment.FileName.Contains(".docx") ? attment.FileName : attment.FileName + ".docx";
                                    var attachment = new System.Net.Mail.Attachment(attment.FileStream, docxFileName);
                                    attachment.ContentType = new ContentType("application/vnd.openxmlformats-officedocument.wordprocessingml.document");
                                    message.Attachments.Add(attachment);
                                }
                                else if (attment.IsTxt != null && attment.IsTxt == true)
                                {
                                    var txtFileName = attment.FileName.Contains(".txt") ? attment.FileName : attment.FileName + ".txt";
                                    var attachment = new System.Net.Mail.Attachment(attment.FileStream, txtFileName, MediaTypeNames.Text.Plain);
                                    message.Attachments.Add(attachment);
                                }
                            }
                        }

                        //Send mail
                        smtp.Send(message);
                    }
                    catch (Exception exception)
                    {
                        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendEmail", "EmailService ", exception.Message), exception);

                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendEmail", "EmailService ", exception.Message), exception);

            }
        }

        public void SendSMS(string mobileNo, string body, LoggedInContext loggedInContext)
        {
            try
            {
                var companySettingsSearchInputModel = new CompanySettingsSearchInputModel();
                companySettingsSearchInputModel.CompanyId = loggedInContext.CompanyGuid;
                companySettingsSearchInputModel.IsSystemApp = null;
                string storageAccountName = string.Empty;
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                List<CompanySettingsSearchOutputModel> companySettings = _masterDataManagementRepository.GetCompanySettings(companySettingsSearchInputModel, loggedInContext, validationMessages).ToList();
                var configuration = new IO.ClickSend.Client.Configuration()
                {
                    //Username = companySettings.Count > 0? companySettings.Where(x => x.Key == "ClickSendAccountEmail").FirstOrDefault().Value:null,
                    //Password = companySettings.Count > 0 ? companySettings.Where(x => x.Key == "ClickSendAccountPassword").FirstOrDefault().Value:null
                    Username = ConfigurationManager.AppSettings["ClickSendAccountEmail"],
                    Password = ConfigurationManager.AppSettings["ClickSendAccountPassword"]
                };
                var smsApi = new SMSApi(configuration);

                var listOfSms = new List<SmsMessage>
                {
                    new SmsMessage(
                        to: mobileNo,
                        body: body ,
                        source: "sdk")
                };

                var smsCollection = new SmsMessageCollection(listOfSms);
                var response = smsApi.SmsSendPost(smsCollection);
            }
            catch (Exception exception)
            {
                LoggingManager.Debug("SCO Generated SMS:" + exception);
            }
        }

        public void SendMail(LoggedInContext loggedInContext, EmailGenericModel emailGenericModel)
        {
            CompanySettingsSearchInputModel companySettingsSearchInputModel = new CompanySettingsSearchInputModel
            {
                Key = "EmailLimitPerDay",
                IsArchived = false
            };

            CompanySettingsSearchInputModel companySettingsModel = new CompanySettingsSearchInputModel();

            CompanyOutputModel companyDetails = _companyStructureRepository.GetCompanyDetails(loggedInContext, new List<ValidationMessage>());

            //CompanySettingsSearchInputModel companySettingMainLogoModel = new CompanySettingsSearchInputModel
            //{
            //    Key = "CompanyRegisatrationLogo",
            //    IsArchived = false
            //};


            //= (_masterDataManagementRepository.GetCompanySettings(companySettingMainLogoModel, loggedInContext, new List<ValidationMessage>())?.FirstOrDefault()?.Value);

            List<CompanySettingsSearchOutputModel> companySettings = _masterDataManagementRepository.GetCompanySettings(companySettingsModel, loggedInContext, new List<ValidationMessage>()).ToList();

            int count = 0;
            int len = companySettings.Count;

            footerValue = emailGenericModel.FooterAddress;

            for (count = 0; count < len; count++)
            {
                if (companySettings[count].Key == "CompanyRegisatrationLogo")
                {
                    mainLogo = companySettings[count].Value;
                }
                if (companySettings[count].Key == "MailFooterAddress")
                {
                    footerValue = companySettings[count].Value;
                }
            }

            emailGenericModel.HtmlContent = emailGenericModel.HtmlContent.Replace("##CompanyLogo##", mainLogo).Replace("##CompanyName##", companyDetails != null ? companyDetails.CompanyName : "").Replace("##Registersite##", companyDetails != null ? companyDetails.RegistrerSiteAddress : "").Replace("##footerName##", footerValue);

            if (loggedInContext.CompanyGuid == Guid.Empty)
            {
                SendEmail(emailGenericModel, loggedInContext, new List<ValidationMessage>());
            }
            else
            {
                int isinlimit = 0;
                int.TryParse(_masterDataManagementRepository.GetCompanySettings(companySettingsSearchInputModel, loggedInContext, new List<ValidationMessage>())?.FirstOrDefault()?.Value, out isinlimit);

                int totalMails = _companyStructureRepository.GetMailsCount(loggedInContext);

                if (totalMails < isinlimit)

                {
                    SendEmail(emailGenericModel, loggedInContext, new List<ValidationMessage>());
                    _companyStructureRepository.InsertSentMail(emailGenericModel, loggedInContext);
                }
            }

        }

        public void SendEmailWithKeys(EmailGenericModel emailGenericModel)
        {
            try
            {
                if (string.IsNullOrEmpty(emailGenericModel.SmtpMail) || string.IsNullOrEmpty(emailGenericModel.SmtpPassword) || string.IsNullOrEmpty(emailGenericModel.SmtpServer) || string.IsNullOrEmpty(emailGenericModel.SmtpServerPort)
                    || string.IsNullOrEmpty(emailGenericModel.FromMailAddress))
                {
                    emailGenericModel.SmtpMail = ConfigurationManager.AppSettings["SmtpEmail"];
                    emailGenericModel.SmtpPassword = ConfigurationManager.AppSettings["SmtpPassword"];
                    emailGenericModel.SmtpServer = ConfigurationManager.AppSettings["SmtpServer"];
                    emailGenericModel.SmtpServerPort = ConfigurationManager.AppSettings["SmtpServerPort"];
                    emailGenericModel.FromMailAddress = ConfigurationManager.AppSettings["FromMailAddress"];
                }
                var fromName = ConfigurationManager.AppSettings["FromName"] ?? "Snovasys Business Suite";

                SmtpClient smtp = new SmtpClient
                {
                    Host = emailGenericModel.SmtpServer,
                    Port = Int32.Parse(emailGenericModel.SmtpServerPort),
                    EnableSsl = true,
                    DeliveryMethod = SmtpDeliveryMethod.Network,
                    UseDefaultCredentials = true,
                    Credentials = new NetworkCredential(emailGenericModel.SmtpMail, emailGenericModel.SmtpPassword)
                };

                using (var message = new MailMessage()
                {
                    From = new MailAddress(emailGenericModel.FromMailAddress, fromName),
                    Subject = emailGenericModel.Subject,
                    Body = emailGenericModel.HtmlContent,
                    IsBodyHtml = true
                })
                {
                    try
                    {
                        //To mails
                        if (emailGenericModel.ToAddresses != null && emailGenericModel.ToAddresses.Length > 0)
                        {

                            foreach (var tomail in emailGenericModel.ToAddresses)
                            {
                                message.To.Add(new MailAddress(tomail));
                            }
                        }

                        //CC mails
                        if (emailGenericModel.CCMails != null && emailGenericModel.CCMails.Length > 0)
                        {
                            foreach (var ccmail in emailGenericModel.CCMails)
                            {
                                message.CC.Add(new MailAddress(ccmail));
                            }
                        }

                        //BCC mails
                        if (emailGenericModel.BCCMails != null && emailGenericModel.BCCMails.Length > 0)
                        {
                            foreach (var bccmail in emailGenericModel.BCCMails)
                            {
                                message.Bcc.Add(new MailAddress(bccmail));
                            }
                        }
                        //IsPdf
                        if (emailGenericModel.IsPdf == null)
                        {
                            emailGenericModel.IsPdf = false;
                        }

                        //Attachments
                        if (emailGenericModel.MailAttachments != null && emailGenericModel.MailAttachments.Count > 0)
                        {
                            foreach (var attment in emailGenericModel.MailAttachments)
                            {
                                if (emailGenericModel.IsPdf != null && emailGenericModel.IsPdf == true)
                                {
                                    var pdfFileName = Guid.NewGuid() + "-" + DateTime.Now.ToString("yyyy/M/dd");
                                    var attachment = new System.Net.Mail.Attachment(attment, pdfFileName, MediaTypeNames.Application.Pdf);
                                    message.Attachments.Add(attachment);
                                }
                                else if (emailGenericModel.IsPdf != null && emailGenericModel.IsPdf == false)
                                {
                                    var excelFileName = Guid.NewGuid() + "-" + DateTime.Now.ToString("yyyy/M/dd") + ".xlsx";
                                    var attachment = new System.Net.Mail.Attachment(attment, excelFileName);
                                    attachment.ContentType = new ContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
                                    message.Attachments.Add(attachment);
                                }
                            }
                        }

                        //Send mail
                        smtp.Send(message);
                    }
                    catch (Exception exception)
                    {
                        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendEmailWithKeys", "EmailService", exception.Message), exception);

                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendEmailWithKeys", "EmailService ", exception.Message), exception);
            }
        }

    }
}