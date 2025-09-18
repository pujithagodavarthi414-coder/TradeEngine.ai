using BTrak.Common;
using Btrak.Dapper.Dal.Partial;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models.CompanyStructure;
using Btrak.Models.MasterData;
using Btrak.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Btrak.Models.SystemManagement;
using System.Net.Mail;
using System.Net.Mime;
using System.Net;

namespace Btrak.Services.MailTemplateActivity
{
    public class MailTemplateActivityService : IMailTemplateActivityService
    {
        public readonly MailTemplateActivityRepository _mailTemplateActivityRepository;
        private string mainLogo;
        private string footerValue;

        public MailTemplateActivityService(MailTemplateActivityRepository mailTemplateActivityRepository)
        {
            _mailTemplateActivityRepository = mailTemplateActivityRepository;
        }

        private void SendEmail(string sqlConectionString,EmailGenericModel emailGenericModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                Console.WriteLine("Entered into SendEmail");

                CompanySearchCriteriaInputModel searchCriteriaModel = new CompanySearchCriteriaInputModel { CompanyId = loggedInContext?.CompanyGuid };
                CompanyOutputModel companyDetails = _mailTemplateActivityRepository.SearchCompanies(sqlConectionString,searchCriteriaModel, loggedInContext, validationMessages).FirstOrDefault();
                SmtpDetailsModel smtpDetails = _mailTemplateActivityRepository.SearchSmtpCredentials(sqlConectionString,loggedInContext, validationMessages, companyDetails.SiteAddress);
                emailGenericModel.SmtpMail = smtpDetails?.SmtpMail;
                emailGenericModel.SmtpPassword = smtpDetails?.SmtpPassword;
                emailGenericModel.SmtpServer = !string.IsNullOrEmpty(smtpDetails?.SmtpServer) ? smtpDetails?.SmtpServer : "smtp.gmail.com";
                emailGenericModel.SmtpServerPort = !string.IsNullOrEmpty(smtpDetails?.SmtpServerPort) ? smtpDetails?.SmtpServerPort : "587";
                emailGenericModel.FromMailAddress = smtpDetails?.SmtpMail;
                emailGenericModel.FromName = smtpDetails?.FromName;
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
                                if(!string.IsNullOrEmpty(ccmail))
                                {
                                    message.CC.Add(new MailAddress(ccmail));
                                }
                            }
                        }

                        //BCC mails
                        if (emailGenericModel.BCCMails != null && emailGenericModel.BCCMails.Length > 0)
                        {
                            foreach (var bccmail in emailGenericModel.BCCMails)
                            {
                                if (!string.IsNullOrEmpty(bccmail))
                                {
                                    message.Bcc.Add(new MailAddress(bccmail));
                                }
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
                        Console.WriteLine("Sent mail details : " + message.ToString());
                    }
                    catch (Exception exception)
                    {
                        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendEmail", "EmailService ", exception.Message), exception);
                        Console.WriteLine(exception);
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendEmail", "EmailService ", exception.Message), exception);
                Console.WriteLine(exception);
            }
        }

        public void SendMail(string sqlConectionString, LoggedInContext loggedInContext, EmailGenericModel emailGenericModel)
        {
            try {
                Console.WriteLine("Entered into SendMail");
                CompanySettingsSearchInputModel companySettingsSearchInputModel = new CompanySettingsSearchInputModel
                {
                    Key = "EmailLimitPerDay",
                    IsArchived = false
                };

                CompanySettingsSearchInputModel companySettingsModel = new CompanySettingsSearchInputModel();

                CompanyOutputModel companyDetails = _mailTemplateActivityRepository.GetCompanyDetails(sqlConectionString, loggedInContext, new List<ValidationMessage>());

                List<CompanySettingsSearchOutputModel> companySettings = _mailTemplateActivityRepository.GetCompanySettings(sqlConectionString, companySettingsModel, loggedInContext, new List<ValidationMessage>()).ToList();

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
                if(!string.IsNullOrEmpty(emailGenericModel.HtmlContent))
                {
                    emailGenericModel.HtmlContent = emailGenericModel.HtmlContent.Replace("##CompanyLogo##", mainLogo).Replace("##CompanyName##", companyDetails != null ? companyDetails.CompanyName : "").Replace("##Registersite##", companyDetails != null ? companyDetails.RegistrerSiteAddress : "").Replace("##footerName##", footerValue);
                }

                if (loggedInContext.CompanyGuid == Guid.Empty)
                {
                    SendEmail(sqlConectionString, emailGenericModel, loggedInContext, new List<ValidationMessage>());
                }
                else
                {
                    int isinlimit = 0;
                    int.TryParse(_mailTemplateActivityRepository.GetCompanySettings(sqlConectionString, companySettingsSearchInputModel, loggedInContext, new List<ValidationMessage>())?.FirstOrDefault()?.Value, out isinlimit);

                    int totalMails = _mailTemplateActivityRepository.GetMailsCount(sqlConectionString, loggedInContext);
                    if (totalMails < isinlimit)
                    {
                        SendEmail(sqlConectionString, emailGenericModel, loggedInContext, new List<ValidationMessage>());
                        _mailTemplateActivityRepository.InsertSentMail(sqlConectionString, emailGenericModel, loggedInContext);
                    }
                }
                Console.WriteLine("Exited from SendMail");

            }
            catch (Exception ex)
            {
                LoggingManager.Debug("Exception" + ex);
                Console.WriteLine(ex);
            }
        }
        

    }
}
