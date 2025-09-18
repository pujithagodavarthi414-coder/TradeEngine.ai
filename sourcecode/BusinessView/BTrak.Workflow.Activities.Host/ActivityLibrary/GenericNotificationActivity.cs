using System;
using System.Collections.Generic;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.CompanyStructure;
using Btrak.Models.Notification;
using Btrak.Models.SystemManagement;
using Btrak.Services.Account;
using Btrak.Services.ComplianceAudit;
using Btrak.Services.Email;
using Btrak.Services.Notification;
using BTrak.Common;
using BTrak.Common.Constants;
using CamundaClient.Dto;
using CamundaClient.Worker;
using Unity;

namespace BTrak.Workflow.Activities.Host.ActivityLibrary
{

    [ExternalTaskTopic("notification-activity")]
    public class GenericNotificationActivity : IExternalTaskAdapter
    {
        public void Execute(ExternalTask externalTask, ref Dictionary<string, object> resultVariables)
        {
            try
            {
                var notificationService = Unity.UnityContainer.Resolve<NotificationService>();
                var _userRepository = Unity.UnityContainer.Resolve<UserRepository>();
                var _emailService = Unity.UnityContainer.Resolve<EmailService>();
                var userService = Unity.UnityContainer.Resolve<UserService>();
                var complianceAuditService = Unity.UnityContainer.Resolve<ComplianceAuditService>();
                var _companyStructureRepository = Unity.UnityContainer.Resolve<CompanyStructureRepository>();
                string message = (string)externalTask.Variables["message"].Value;
                //Guid ownerId = new Guid((string)externalTask.Variables["ownerId"].Value);
                string responsibleUser = externalTask.Variables.ContainsKey("responsibleUser") && externalTask.Variables["responsibleUser"]?.Value != null ? Convert.ToString(externalTask.Variables["responsibleUser"].Value) : string.Empty;
                string spanInDays = externalTask.Variables.ContainsKey("spanInDays") && externalTask.Variables["spanInDays"]?.Value != null ? Convert.ToString(externalTask.Variables["spanInDays"].Value) : string.Empty;
                bool isForAuditRecurringMail = externalTask.Variables.ContainsKey("isForAuditRecurringMail") && externalTask.Variables["isForAuditRecurringMail"]?.Value != null ? bool.Parse((string)externalTask.Variables["isForAuditRecurringMail"].Value) : false;
                bool isForAuditDeadLineRecurringMail = externalTask.Variables.ContainsKey("isForAuditDeadLineRecurringMail") && externalTask.Variables["isForAuditDeadLineRecurringMail"]?.Value != null ? bool.Parse((string)externalTask.Variables["isForAuditDeadLineRecurringMail"].Value) : false;
                string spanInDaysForConductDeadLineMail = externalTask.Variables.ContainsKey("spanInDaysForConductDeadLineMail") && externalTask.Variables["spanInDaysForConductDeadLineMail"]?.Value != null ? Convert.ToString(externalTask.Variables["spanInDaysForConductDeadLineMail"].Value) : string.Empty;
                var companyId = (string)externalTask.Variables["companyId"].Value;
                var loggedUserId = (string)externalTask.Variables["loggedUserId"].Value;
                var loggedInContext = new LoggedInContext
                {
                    LoggedInUserId = new Guid(loggedUserId),
                    CompanyGuid = new Guid(companyId)
                };
                LoggingManager.Debug("Enter into notification activity and fetching details");
                LoggingManager.Debug("GetUserDetailsByNameAndCompanyId");
                var owner = _userRepository.GetUserDetailsByNameAndCompanyId(responsibleUser, new Guid(companyId));
                var validationMessages = new List<ValidationMessage>();
                var companyDetails = _companyStructureRepository.SearchCompanies(new CompanySearchCriteriaInputModel() { CompanyId = new Guid(companyId), ForSuperUser = true }, validationMessages);
                LoggingManager.Debug("responsibleUser:" + responsibleUser.ToString());
                LoggingManager.Debug("companyId:" + companyId?.ToString());
                LoggingManager.Debug("loggedUserId:" + loggedUserId?.ToString());
                LoggingManager.Debug("spanInDays:" + spanInDays?.ToString());
                LoggingManager.Debug("spanInDaysForConductDeadLineMail:" + spanInDaysForConductDeadLineMail?.ToString());
                LoggingManager.Debug("isForAuditRecurringMail:" + isForAuditRecurringMail.ToString());
                LoggingManager.Debug("isForAuditRecurringMail:" + isForAuditDeadLineRecurringMail.ToString());
                Guid ownerId = Guid.Empty;
                LoggingManager.Debug("Fetched owner");
                if (owner != null)
                {
                    LoggingManager.Debug("owner is null");
                    ownerId = owner.Id;
                }
                LoggingManager.Debug("owner:" + owner?.ToString());
                LoggingManager.Debug("ownerId:" + ownerId.ToString());
                if (ownerId != Guid.Empty && ownerId != null && spanInDays != null && spanInDays != "" && int.Parse(spanInDays) != null && int.Parse(spanInDays) > 0 && isForAuditRecurringMail == true)
                {

                    LoggingManager.Debug("Entered into start date and fetching audits");
                    var audits = complianceAuditService.GetRecurringAuditsForSendingMails(int.Parse(spanInDays), ownerId);
                    LoggingManager.Debug("fetched audits");
                    if (audits != null && audits.Count > 0)
                    {
                        LoggingManager.Debug("audits are not null");
                        foreach (var a in audits)
                        {

                            notificationService.SendNotification(
                           new GenericActivityNotification(
                            "The audit " + a.AuditConductName + " is going start with in " + spanInDays + " days.Please be ready.",
                            loggedInContext.LoggedInUserId,
                            ownerId
                            ), loggedInContext, ownerId);
                            LoggingManager.Debug("Looping audits and getting smtp details");
                            SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, new List<ValidationMessage>(), null);
                            LoggingManager.Debug("fetched smtp details");
                            string style = "* {- webkit - font - smoothing: antialiased;}body {Margin: 0; padding: 0; min - width: 100 %; font - family: Arial, sans - serif; -webkit - font - smoothing: antialiased; mso - line - height - rule: exactly;}table {border - spacing: 0; color: #333333;font-family: Arial, sans-serif;}img { border: 0;}.wrapper { width: 100 %; table - layout: fixed; -webkit - text - size - adjust: 100 %; -ms - text - size - adjust: 100 %;}.webkit { max - width: 600px;}.outer { Margin: 0 auto; width: 100 %; max - width: 600px;}.full - width - image img{width: 100 %; max - width: 600px; height: auto;}.inner { padding: 10px;}p { Margin: 0; padding - bottom: 10px;}.h1 { font - size: 21px; font - weight: bold; Margin - top: 15px; Margin - bottom: 5px; font - family: Arial, sans - serif; -webkit - font - smoothing: antialiased;}.h2 { font - size: 18px; font - weight: bold; Margin - top: 10px; Margin - bottom: 5px; font - family: Arial, sans - serif; -webkit - font - smoothing: antialiased;}";
                            style += ".one - column.contents { text - align: left; font - family: Arial, sans - serif; -webkit - font - smoothing: antialiased;}.one - column p{    font - size: 14px; Margin - bottom: 10px; font - family: Arial, sans - serif; -webkit - font - smoothing: antialiased;}.two - column { text - align: center; font - size: 0;                }.two - column.column { width: 100 %; max - width: 300px; display: inline - block; vertical - align: top;                }.contents { width: 100 %;                }.two - column.contents { font - size: 14px; text - align: left;                }.two - column img{    width: 100 %; max - width: 280px; height: auto;}.two - column.text { padding - top: 10px;                }.three - column { text - align: center; font - size: 0; padding - top: 10px; padding - bottom: 10px;                }.three - column.column { width: 100 %; max - width: 200px; display: inline - block; vertical - align: top;                }.three - column.contents { font - size: 14px; text - align: center;                }.three - column img{    width: 100 %; max - width: 180px; height: auto;}.three - column.text { padding - top: 10px;                }.img - align - vertical img{    display: inline - block; vertical - align: middle;}@@media only screen and(max-device - width: 480px) { table[class=hide], img[class=hide], td[class=hide] {display: none !important;}.contents1 {width: 100%;}.contents1 {width: 100%;}}";
                            var html = "<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /><meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\" /><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />";
                            html += "<style type=\"text/css\">* {-webkit-font-smoothing: antialiased;}body {Margin: 0;padding: 0;min-width: 100%;font-family: Arial, sans-serif;-webkit-font-smoothing: antialiased;mso-line-height-rule: exactly;}";
                            html += "table {border-spacing: 0;color: #333333;font-family: Arial, sans-serif;}img {border: 0;}.wrapper { width: 100%;table-layout: fixed;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;}.webkit { max-width: 600px;}.outer {Margin: 0 auto;width: 100%;max-width: 600px;}.full-width-image img {width: 100%;max-width: 600px; height: auto;}.inner { padding: 10px;}p {Margin: 0;padding-bottom: 10px;}.h1 { font-size: 21px;font-weight: bold; Margin-top: 15px;Margin-bottom: 5px;font-family: Arial, sans-serif;-webkit-font-smoothing: antialiased;}.h2 {font-size: 18px;font-weight: bold;Margin-top: 10px;Margin-bottom: 5px;font-family: Arial, sans-serif;-webkit-font-smoothing: antialiased;}.one-column .contents {text-align: left;font-family: Arial, sans-serif;-webkit-font-smoothing: antialiased;}.one-column p {font-size: 14px;Margin-bottom: 10px;font-family: Arial, sans-serif;-webkit-font-smoothing: antialiased;}.two-column {text-align: center;font-size: 0;}.two-column .column {width: 100%;max-width: 300px;display: inline-block;vertical-align: top;}.contents {width: 100%;}.two-column .contents {font-size: 14px;text-align: left;}.two-column img {width: 100%;max-width: 280px;height: auto;}.two-column .text {padding-top: 10px;}.three-column {text-align: center;font-size: 0;padding-top: 10px;padding-bottom: 10px;}.three-column .column {width: 100%;max-width: 200px;display: inline-block;vertical-align: top;}.three-column .contents {font-size: 14px;text-align: center;}.three-column img {width: 100%;max-width: 180px;height: auto;}.three-column .text {padding-top: 10px;}.img-align-vertical img {display: inline-block;vertical-align: middle;}@@media only screen and (max-device-width: 480px) {table[class=hide], img[class=hide], td[class=hide] {display: none !important;}.contents1 {width: 100%;}.contents1 {width: 100%;}}</style></head><bodystyle=\"Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;\"><center class=\"wrapper\"style=\"width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;\"><table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"background-color:#f3f2f0;\"bgcolor=\"#f3f2f0;\"><tr><td width=\"100%\"><div class=\"webkit\" style=\"max-width:600px;Margin:0 auto;\"><table class=\"outer\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\"style=\"border-spacing:0;Margin:0 auto;width:100%;max-width:600px;\"><tr><td style=\"padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;\"><table class=\"one-column\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\"style=\"border-spacing:0; border-left:1px solid #e8e7e5; ";
                            html += "border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5\"bgcolor=\"#FFFFFF\"><tr><td align=\"left\" style=\"padding:50px 50px 50px 50px\"><p style=\"color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif\"><h2>Dear "+ owner.FullName + ",</h2></p><p style=\"color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px \">Thank you for choosing Snovasys Business Suite to grow your business.Hope you have a great success in the coming future. <br />" + "The audit " + a.AuditConductName + " is going start with in "+ spanInDays +" days.Please be ready." + "<br /><br /></p><p style=\"color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px \">Best Regards, <br />" + companyDetails[0].CompanyName + "</p></td></tr></table></td></tr></table></div></td></tr></table></center></body></html>";


                            //string html = "<html><body>The audit " + a.AuditConductName + " is going start with in "+ spanInDays +" days. Please be ready.</body></html>";

                            TaskWrapper.ExecuteFunctionInNewThread(() =>
                            {
                                EmailGenericModel emailModel = new EmailGenericModel
                                {
                                    SmtpServer = smtpDetails?.SmtpServer,
                                    SmtpServerPort = smtpDetails?.SmtpServerPort,
                                    SmtpMail = smtpDetails?.SmtpMail,
                                    SmtpPassword = smtpDetails?.SmtpPassword,
                                    ToAddresses = new string[] { responsibleUser },
                                    HtmlContent = html,
                                    Subject = "Snovasys Business Suite: Audit " + a.AuditConductName + " near to conduct",
                                    // CCMails = ccEmails,
                                    //BCCMails = bccEmails,
                                    MailAttachments = null,
                                    IsPdf = null
                                };
                                LoggingManager.Debug("Mail metod calling");
                                _emailService.SendMail(loggedInContext, emailModel);
                            });
                        }
                    }
                    LoggingManager.Debug("audits null");
                    LoggingManager.Debug("End of first if");
                }
                else if (ownerId != Guid.Empty && ownerId != null && spanInDaysForConductDeadLineMail != null && spanInDaysForConductDeadLineMail != "" && int.Parse(spanInDaysForConductDeadLineMail) != null && int.Parse(spanInDaysForConductDeadLineMail) > 0 && isForAuditDeadLineRecurringMail == true)
                {

                    LoggingManager.Debug("Entered into deadline date and fetching audits");
                    var audits = complianceAuditService.GetRecurringAuditsForSendingDeadLineMails(int.Parse(spanInDaysForConductDeadLineMail), ownerId);
                    LoggingManager.Debug("fetched audits");
                    if (audits != null && audits.Count > 0)
                    {
                        LoggingManager.Debug("audits are not null");
                        foreach (var a in audits)
                        {

                            // notificationService.SendNotification(
                            //new GenericActivityNotification(
                            // "The audit " + a.AuditConductName + " is going end with in " + spanInDaysForConductDeadLineMail + " days.Please complete it.",
                            // loggedInContext.LoggedInUserId,
                            // ownerId
                            // ), loggedInContext, ownerId);
                            LoggingManager.Debug("Looping audits and getting smtp details");
                            SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, new List<ValidationMessage>(), null);
                            LoggingManager.Debug("fetched smtp details");
                            string style = "* {- webkit - font - smoothing: antialiased;}body {Margin: 0; padding: 0; min - width: 100 %; font - family: Arial, sans - serif; -webkit - font - smoothing: antialiased; mso - line - height - rule: exactly;}table {border - spacing: 0; color: #333333;font-family: Arial, sans-serif;}img { border: 0;}.wrapper { width: 100 %; table - layout: fixed; -webkit - text - size - adjust: 100 %; -ms - text - size - adjust: 100 %;}.webkit { max - width: 600px;}.outer { Margin: 0 auto; width: 100 %; max - width: 600px;}.full - width - image img{width: 100 %; max - width: 600px; height: auto;}.inner { padding: 10px;}p { Margin: 0; padding - bottom: 10px;}.h1 { font - size: 21px; font - weight: bold; Margin - top: 15px; Margin - bottom: 5px; font - family: Arial, sans - serif; -webkit - font - smoothing: antialiased;}.h2 { font - size: 18px; font - weight: bold; Margin - top: 10px; Margin - bottom: 5px; font - family: Arial, sans - serif; -webkit - font - smoothing: antialiased;}";
                            style += ".one - column.contents { text - align: left; font - family: Arial, sans - serif; -webkit - font - smoothing: antialiased;}.one - column p{    font - size: 14px; Margin - bottom: 10px; font - family: Arial, sans - serif; -webkit - font - smoothing: antialiased;}.two - column { text - align: center; font - size: 0;                }.two - column.column { width: 100 %; max - width: 300px; display: inline - block; vertical - align: top;                }.contents { width: 100 %;                }.two - column.contents { font - size: 14px; text - align: left;                }.two - column img{    width: 100 %; max - width: 280px; height: auto;}.two - column.text { padding - top: 10px;                }.three - column { text - align: center; font - size: 0; padding - top: 10px; padding - bottom: 10px;                }.three - column.column { width: 100 %; max - width: 200px; display: inline - block; vertical - align: top;                }.three - column.contents { font - size: 14px; text - align: center;                }.three - column img{    width: 100 %; max - width: 180px; height: auto;}.three - column.text { padding - top: 10px;                }.img - align - vertical img{    display: inline - block; vertical - align: middle;}@@media only screen and(max-device - width: 480px) { table[class=hide], img[class=hide], td[class=hide] {display: none !important;}.contents1 {width: 100%;}.contents1 {width: 100%;}}";
                            var html = "<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /><meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\" /><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />";
                            html += "<style type=\"text/css\">* {-webkit-font-smoothing: antialiased;}body {Margin: 0;padding: 0;min-width: 100%;font-family: Arial, sans-serif;-webkit-font-smoothing: antialiased;mso-line-height-rule: exactly;}";
                            html += "table {border-spacing: 0;color: #333333;font-family: Arial, sans-serif;}img {border: 0;}.wrapper { width: 100%;table-layout: fixed;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;}.webkit { max-width: 600px;}.outer {Margin: 0 auto;width: 100%;max-width: 600px;}.full-width-image img {width: 100%;max-width: 600px; height: auto;}.inner { padding: 10px;}p {Margin: 0;padding-bottom: 10px;}.h1 { font-size: 21px;font-weight: bold; Margin-top: 15px;Margin-bottom: 5px;font-family: Arial, sans-serif;-webkit-font-smoothing: antialiased;}.h2 {font-size: 18px;font-weight: bold;Margin-top: 10px;Margin-bottom: 5px;font-family: Arial, sans-serif;-webkit-font-smoothing: antialiased;}.one-column .contents {text-align: left;font-family: Arial, sans-serif;-webkit-font-smoothing: antialiased;}.one-column p {font-size: 14px;Margin-bottom: 10px;font-family: Arial, sans-serif;-webkit-font-smoothing: antialiased;}.two-column {text-align: center;font-size: 0;}.two-column .column {width: 100%;max-width: 300px;display: inline-block;vertical-align: top;}.contents {width: 100%;}.two-column .contents {font-size: 14px;text-align: left;}.two-column img {width: 100%;max-width: 280px;height: auto;}.two-column .text {padding-top: 10px;}.three-column {text-align: center;font-size: 0;padding-top: 10px;padding-bottom: 10px;}.three-column .column {width: 100%;max-width: 200px;display: inline-block;vertical-align: top;}.three-column .contents {font-size: 14px;text-align: center;}.three-column img {width: 100%;max-width: 180px;height: auto;}.three-column .text {padding-top: 10px;}.img-align-vertical img {display: inline-block;vertical-align: middle;}@@media only screen and (max-device-width: 480px) {table[class=hide], img[class=hide], td[class=hide] {display: none !important;}.contents1 {width: 100%;}.contents1 {width: 100%;}}</style></head><bodystyle=\"Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;\"><center class=\"wrapper\"style=\"width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;\"><table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"background-color:#f3f2f0;\"bgcolor=\"#f3f2f0;\"><tr><td width=\"100%\"><div class=\"webkit\" style=\"max-width:600px;Margin:0 auto;\"><table class=\"outer\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\"style=\"border-spacing:0;Margin:0 auto;width:100%;max-width:600px;\"><tr><td style=\"padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;\"><table class=\"one-column\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\"style=\"border-spacing:0; border-left:1px solid #e8e7e5; ";
                            html += "border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5\"bgcolor=\"#FFFFFF\"><tr><td align=\"left\" style=\"padding:50px 50px 50px 50px\"><p style=\"color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif\"><h2>Dear " + owner.FullName + ",</h2></p><p style=\"color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px \">Thank you for choosing Snovasys Business Suite to grow your business.Hope you have a great success in the coming future. <br />" + "The conduct " + a.AuditConductName + " is going to end with in  " + spanInDays + " days.Please complete the conduct." + "<br /><br /></p><p style=\"color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px \">Best Regards, <br />" + companyDetails[0].CompanyName +  "</p></td></tr></table></td></tr></table></div></td></tr></table></center></body></html>";


                            //string html = "<html><body>The audit " + a.AuditConductName + " is going start with in "+ spanInDays +" days. Please be ready.</body></html>";

                            TaskWrapper.ExecuteFunctionInNewThread(() =>
                            {
                                EmailGenericModel emailModel = new EmailGenericModel
                                {
                                    SmtpServer = smtpDetails?.SmtpServer,
                                    SmtpServerPort = smtpDetails?.SmtpServerPort,
                                    SmtpMail = smtpDetails?.SmtpMail,
                                    SmtpPassword = smtpDetails?.SmtpPassword,
                                    ToAddresses = new string[] { responsibleUser },
                                    HtmlContent = html,
                                    Subject = "Snovasys Business Suite: Conduct " + a.AuditConductName + " near to end",
                                    // CCMails = ccEmails,
                                    //BCCMails = bccEmails,
                                    MailAttachments = null,
                                    IsPdf = null
                                };
                                LoggingManager.Debug("Mail metod calling");
                                _emailService.SendMail(loggedInContext, emailModel);
                            });
                        }
                    }
                    LoggingManager.Debug("audits null");
                    LoggingManager.Debug("End of first if");
                }
                else if (isForAuditRecurringMail != true && isForAuditDeadLineRecurringMail != true && ownerId != Guid.Empty && ownerId != null)
                {
                    LoggingManager.Debug("Entered second if");
                    if (ownerId != null && ownerId != Guid.Empty)
                    {
                        notificationService.SendNotification(
                       new GenericActivityNotification(
                        message,
                        loggedInContext.LoggedInUserId,
                        ownerId
                        ), loggedInContext, ownerId);
                    }
                    SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, new List<ValidationMessage>(), null);

                    string style = "* {- webkit - font - smoothing: antialiased;}body {Margin: 0; padding: 0; min - width: 100 %; font - family: Arial, sans - serif; -webkit - font - smoothing: antialiased; mso - line - height - rule: exactly;}table {border - spacing: 0; color: #333333;font-family: Arial, sans-serif;}img { border: 0;}.wrapper { width: 100 %; table - layout: fixed; -webkit - text - size - adjust: 100 %; -ms - text - size - adjust: 100 %;}.webkit { max - width: 600px;}.outer { Margin: 0 auto; width: 100 %; max - width: 600px;}.full - width - image img{width: 100 %; max - width: 600px; height: auto;}.inner { padding: 10px;}p { Margin: 0; padding - bottom: 10px;}.h1 { font - size: 21px; font - weight: bold; Margin - top: 15px; Margin - bottom: 5px; font - family: Arial, sans - serif; -webkit - font - smoothing: antialiased;}.h2 { font - size: 18px; font - weight: bold; Margin - top: 10px; Margin - bottom: 5px; font - family: Arial, sans - serif; -webkit - font - smoothing: antialiased;}";
                    style += ".one - column.contents { text - align: left; font - family: Arial, sans - serif; -webkit - font - smoothing: antialiased;}.one - column p{    font - size: 14px; Margin - bottom: 10px; font - family: Arial, sans - serif; -webkit - font - smoothing: antialiased;}.two - column { text - align: center; font - size: 0;                }.two - column.column { width: 100 %; max - width: 300px; display: inline - block; vertical - align: top;                }.contents { width: 100 %;                }.two - column.contents { font - size: 14px; text - align: left;                }.two - column img{    width: 100 %; max - width: 280px; height: auto;}.two - column.text { padding - top: 10px;                }.three - column { text - align: center; font - size: 0; padding - top: 10px; padding - bottom: 10px;                }.three - column.column { width: 100 %; max - width: 200px; display: inline - block; vertical - align: top;                }.three - column.contents { font - size: 14px; text - align: center;                }.three - column img{    width: 100 %; max - width: 180px; height: auto;}.three - column.text { padding - top: 10px;                }.img - align - vertical img{    display: inline - block; vertical - align: middle;}@@media only screen and(max-device - width: 480px) { table[class=hide], img[class=hide], td[class=hide] {display: none !important;}.contents1 {width: 100%;}.contents1 {width: 100%;}}";
                    var html = "<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /><meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\" /><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />";
                    html += "<style type=\"text/css\">* {-webkit-font-smoothing: antialiased;}body {Margin: 0;padding: 0;min-width: 100%;font-family: Arial, sans-serif;-webkit-font-smoothing: antialiased;mso-line-height-rule: exactly;}";
                    html += "table {border-spacing: 0;color: #333333;font-family: Arial, sans-serif;}img {border: 0;}.wrapper { width: 100%;table-layout: fixed;-webkit-text-size-adjust: 100%;-ms-text-size-adjust: 100%;}.webkit { max-width: 600px;}.outer {Margin: 0 auto;width: 100%;max-width: 600px;}.full-width-image img {width: 100%;max-width: 600px; height: auto;}.inner { padding: 10px;}p {Margin: 0;padding-bottom: 10px;}.h1 { font-size: 21px;font-weight: bold; Margin-top: 15px;Margin-bottom: 5px;font-family: Arial, sans-serif;-webkit-font-smoothing: antialiased;}.h2 {font-size: 18px;font-weight: bold;Margin-top: 10px;Margin-bottom: 5px;font-family: Arial, sans-serif;-webkit-font-smoothing: antialiased;}.one-column .contents {text-align: left;font-family: Arial, sans-serif;-webkit-font-smoothing: antialiased;}.one-column p {font-size: 14px;Margin-bottom: 10px;font-family: Arial, sans-serif;-webkit-font-smoothing: antialiased;}.two-column {text-align: center;font-size: 0;}.two-column .column {width: 100%;max-width: 300px;display: inline-block;vertical-align: top;}.contents {width: 100%;}.two-column .contents {font-size: 14px;text-align: left;}.two-column img {width: 100%;max-width: 280px;height: auto;}.two-column .text {padding-top: 10px;}.three-column {text-align: center;font-size: 0;padding-top: 10px;padding-bottom: 10px;}.three-column .column {width: 100%;max-width: 200px;display: inline-block;vertical-align: top;}.three-column .contents {font-size: 14px;text-align: center;}.three-column img {width: 100%;max-width: 180px;height: auto;}.three-column .text {padding-top: 10px;}.img-align-vertical img {display: inline-block;vertical-align: middle;}@@media only screen and (max-device-width: 480px) {table[class=hide], img[class=hide], td[class=hide] {display: none !important;}.contents1 {width: 100%;}.contents1 {width: 100%;}}</style></head><bodystyle=\"Margin:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;min-width:100%;background-color:#f3f2f0;\"><center class=\"wrapper\"style=\"width:100%;table-layout:fixed;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;background-color:#f3f2f0;\"><table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"background-color:#f3f2f0;\"bgcolor=\"#f3f2f0;\"><tr><td width=\"100%\"><div class=\"webkit\" style=\"max-width:600px;Margin:0 auto;\"><table class=\"outer\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\"style=\"border-spacing:0;Margin:0 auto;width:100%;max-width:600px;\"><tr><td style=\"padding-top:0;padding-bottom:0;padding-right:0;padding-left:0;\"><table class=\"one-column\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\"style=\"border-spacing:0; border-left:1px solid #e8e7e5; ";
                    html += "border-right:1px solid #e8e7e5; border-bottom:1px solid #e8e7e5; border-top:1px solid #e8e7e5\"bgcolor=\"#FFFFFF\"><tr><td align=\"left\" style=\"padding:50px 50px 50px 50px\"><p style=\"color:#262626; font-size:24px; text-align:left; font-family: Verdana, Geneva, sans-serif\"><h2>Dear "+ owner.FullName + ",</h2></p><p style=\"color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px \">Thank you for choosing Snovasys Business Suite to grow your business.Hope you have a great success in the coming future. <br />" + message + "<br /><br /></p><p style=\"color:#000000; font-size:16px; text-align:left; font-family: Verdana, Geneva, sans-serif; line-height:22px \">Best Regards, <br />" + companyDetails[0].CompanyName + "</p></td></tr></table></td></tr></table></div></td></tr></table></center></body></html>";

                    TaskWrapper.ExecuteFunctionInNewThread(() =>
                    {
                        EmailGenericModel emailModel = new EmailGenericModel
                        {
                            SmtpServer = smtpDetails?.SmtpServer,
                            SmtpServerPort = smtpDetails?.SmtpServerPort,
                            SmtpMail = smtpDetails?.SmtpMail,
                            SmtpPassword = smtpDetails?.SmtpPassword,
                            ToAddresses = new string[] { responsibleUser },
                            HtmlContent = html,
                            Subject = "Snovasys Business Suite: Notification from snovasys",
                            // CCMails = ccEmails,
                            //BCCMails = bccEmails,
                            MailAttachments = null,
                            IsPdf = null
                        };
                        _emailService.SendMail(loggedInContext, emailModel);
                    });
                }
            }
            catch (Exception ex)
            {
                LoggingManager.Debug("Exception" + ex);
                Console.WriteLine(ex);
            }
        }
    }
}
