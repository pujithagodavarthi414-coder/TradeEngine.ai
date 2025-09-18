using AuthenticationServices.Common;
using AuthenticationServices.Models;
using AuthenticationServices.Models.CompanyStructure;
using AuthenticationServices.Models.Email;
using AuthenticationServices.Models.MasterData;
using AuthenticationServices.Models.SystemManagement;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using System.Text;
using AuthenticationServices.Repositories.Repositories.CompanyManagement;
using AuthenticationServices.Repositories.Repositories.UserManagement;

namespace AuthenticationServices.Services.Email
{
    public class EmailService : IEmailService
    {
        IConfiguration _iconfiguration;
        private readonly IUserManagementRepository _userManagementRepository;
        private readonly ICompanyManagementRepository _companyManagementRepository;
        private string mainLogo;
        private string footerValue;
        public EmailService(IUserManagementRepository userManagementRepository, ICompanyManagementRepository companyManagementRepository, IConfiguration iconfiguration)
        {
            _userManagementRepository = userManagementRepository;
            _companyManagementRepository = companyManagementRepository;
            _iconfiguration = iconfiguration;
        }
        public void SendEmailToUserWithContent(EmailModel emailModel)
        {
            if (emailModel == null)
            {
                throw new ArgumentNullException(nameof(emailModel));
            }

            try
            {
                SmtpClient smtp = new SmtpClient
                {
                    Host = _iconfiguration["SmtpServer"],
                    Port = Int32.Parse(_iconfiguration["SmtpServerPort"]),
                    EnableSsl = bool.Parse(_iconfiguration["UseSsl"]),
                    DeliveryMethod = SmtpDeliveryMethod.Network,
                    UseDefaultCredentials = false,
                    Credentials = new NetworkCredential(_iconfiguration["SmtpEmail"], _iconfiguration["SmtpPassword"])
                };

                using (var message = new MailMessage(_iconfiguration["FromMailAddress"], emailModel.ToAddress)
                {
                    Subject = "[Super admin site] " + emailModel.Subject,
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
                //CompanySearchCriteriaInputModel searchCriteriaModel = new CompanySearchCriteriaInputModel { CompanyId = loggedInContext?.CompanyGuid };
                //CompanyOutputModel companyDetails = _companyManagementRepository.SearchCompanies(searchCriteriaModel, loggedInContext, validationMessages).FirstOrDefault();
                SmtpDetailsModel smtpDetails = _userManagementRepository.SearchSmtpCredentials(loggedInContext, validationMessages, null);
                emailGenericModel.SmtpMail = smtpDetails?.SmtpMail;
                emailGenericModel.SmtpPassword = smtpDetails?.SmtpPassword;
                emailGenericModel.SmtpServer = smtpDetails?.SmtpServer;
                emailGenericModel.SmtpServerPort = smtpDetails?.SmtpServerPort;
                emailGenericModel.FromMailAddress = smtpDetails?.FromAddress;
                emailGenericModel.FromName = smtpDetails?.FromName;

                if (string.IsNullOrEmpty(emailGenericModel.SmtpMail) || string.IsNullOrEmpty(emailGenericModel.SmtpPassword) || string.IsNullOrEmpty(emailGenericModel.SmtpServer) || string.IsNullOrEmpty(emailGenericModel.SmtpServerPort)
                    || string.IsNullOrEmpty(emailGenericModel.FromMailAddress))
                {
                    emailGenericModel.SmtpMail = _iconfiguration["SmtpEmail"];
                    emailGenericModel.SmtpPassword = _iconfiguration["SmtpPassword"];
                    emailGenericModel.SmtpServer = _iconfiguration["SmtpServer"];
                    emailGenericModel.SmtpServerPort = _iconfiguration["SmtpServerPort"];
                    emailGenericModel.FromMailAddress = _iconfiguration["FromMailAddress"];
                    emailGenericModel.FromName = _iconfiguration["FromName"] ?? "Super admin site";
                }

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
                                    var pdfFileName = Guid.NewGuid() + "-" + DateTime.Now.ToString("yyyy/M/dd");
                                    var attachment = new Attachment(attment, pdfFileName, MediaTypeNames.Application.Pdf);
                                    message.Attachments.Add(attachment);
                                }
                                else if (emailGenericModel.IsPdf != null && emailGenericModel.IsPdf == false)
                                {
                                    var excelFileName = Guid.NewGuid() + "-" + DateTime.Now.ToString("yyyy/M/dd") + ".xlsx";
                                    var attachment = new Attachment(attment, excelFileName);
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
                        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendEmail", "EmailService ", exception.Message), exception);

                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendEmail", "EmailService ", exception.Message), exception);

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

            CompanyOutputModel companyDetails = _companyManagementRepository.GetCompanyDetails(loggedInContext, new List<ValidationMessage>());

            //CompanySettingsSearchInputModel companySettingMainLogoModel = new CompanySettingsSearchInputModel
            //{
            //    Key = "CompanyRegisatrationLogo",
            //    IsArchived = false
            //};


            //= (_masterDataManagementRepository.GetCompanySettings(companySettingMainLogoModel, loggedInContext, new List<ValidationMessage>())?.FirstOrDefault()?.Value);

            List<CompanySettingsSearchOutputModel> companySettings = _companyManagementRepository.GetCompanySettings(companySettingsModel, loggedInContext, new List<ValidationMessage>()).ToList();

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
                int.TryParse(_companyManagementRepository.GetCompanySettings(companySettingsSearchInputModel, loggedInContext, new List<ValidationMessage>())?.FirstOrDefault()?.Value, out isinlimit);

                int totalMails = _companyManagementRepository.GetMailsCount(loggedInContext);

                if (totalMails <= isinlimit)

                {
                    SendEmail(emailGenericModel, loggedInContext, new List<ValidationMessage>());
                    _companyManagementRepository.InsertSentMail(emailGenericModel, loggedInContext);
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
                    emailGenericModel.SmtpMail = _iconfiguration["SmtpEmail"];
                    emailGenericModel.SmtpPassword = _iconfiguration["SmtpPassword"];
                    emailGenericModel.SmtpServer = _iconfiguration["SmtpServer"];
                    emailGenericModel.SmtpServerPort = _iconfiguration["SmtpServerPort"];
                    emailGenericModel.FromMailAddress = _iconfiguration["FromMailAddress"];
                }
                var fromName = _iconfiguration["FromName"] ?? "Super admin site";

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
                                    var attachment = new Attachment(attment, pdfFileName, MediaTypeNames.Application.Pdf);
                                    message.Attachments.Add(attachment);
                                }
                                else if (emailGenericModel.IsPdf != null && emailGenericModel.IsPdf == false)
                                {
                                    var excelFileName = Guid.NewGuid() + "-" + DateTime.Now.ToString("yyyy/M/dd") + ".xlsx";
                                    var attachment = new Attachment(attment, excelFileName);
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
