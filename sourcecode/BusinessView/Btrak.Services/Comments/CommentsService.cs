using System;
using System.Collections.Generic;
using System.Linq;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.Comments;
using Btrak.Models.Notification;
using Btrak.Models.UserStory;
using Btrak.Services.Audit;
using Btrak.Services.Notification;
using Btrak.Services.User;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.Comments;
using BTrak.Common;
using BTrak.Common.Constants;
using Btrak.Dapper.Dal.Partial;
using Btrak.Models.AdhocWork;
using Btrak.Models.User;
using Btrak.Models.CompanyStructure;
using Btrak.Models.SystemManagement;
using Btrak.Services.CompanyStructure;
using Hangfire;
using UserSearchCriteriaInputModel = Btrak.Models.User.UserSearchCriteriaInputModel;
using Btrak.Models.SoftLabelConfigurations;
using System.Text.RegularExpressions;
using Btrak.Services.Email;
using System.Configuration;

namespace Btrak.Services.Comments
{
    public class CommentsService : ICommentsService
    {
        private readonly CommentRepository _commentsRepository;
        private readonly IAuditService _auditService;
        private readonly INotificationService _notificationService;
        private readonly UserStoryRepository _userStoryRepository;
        private readonly IUserService _userService;
        private readonly GoalRepository _goalRepository;
        private readonly ICompanyStructureService _companyStructureService;
        private readonly UserRepository _userRepository;
        private readonly AdhocWorkRepository _adhocWorkRepository;
        private readonly MasterDataManagementRepository _masterDataManagementRepository;
        private readonly IEmailService _emailService;

        public CommentsService(CommentRepository commentsRepository, IAuditService auditService, INotificationService notificationService, UserStoryRepository userStoryRepository, IUserService userService, ICompanyStructureService companyStructureService,
            GoalRepository goalRepository, UserRepository userRepository, AdhocWorkRepository adhocWorkRepository, MasterDataManagementRepository masterDataManagementRepository,
            IEmailService emailService)
        {
            _commentsRepository = commentsRepository;
            _auditService = auditService;
            _notificationService = notificationService;
            _userStoryRepository = userStoryRepository;
            _userService = userService;
            _goalRepository = goalRepository;
            _companyStructureService = companyStructureService;
            _userRepository = userRepository;
            _adhocWorkRepository = adhocWorkRepository;
            _masterDataManagementRepository = masterDataManagementRepository;
            _emailService = emailService;
        }

        public Guid? UpsertComment(CommentUserInputModel commentModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            commentModel.Comment = commentModel.Comment?.Trim();

            if (!CommentValidations.ValidateCommentUpsertInputModel(commentModel, loggedInContext, validationMessages))
            {
                return null;
            }

            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                commentModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (commentModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                commentModel.TimeZone = indianTimeDetails?.TimeZone;
            }

            commentModel.CommentId = _commentsRepository.UpsertComment(commentModel, loggedInContext, validationMessages);

            LoggingManager.Debug(commentModel.CommentId?.ToString());

            _auditService.SaveAudit(AppCommandConstants.UpsertCommentCommandId, commentModel, loggedInContext);

            SendNotificationAndEmailForUserStoryComment(commentModel, loggedInContext, new List<ValidationMessage>());

            SendPushNotificationForaComment(commentModel.ReceiverId, loggedInContext, new List<ValidationMessage>());

            return commentModel.CommentId;
        }

        private void SendNotificationAndEmailForUserStoryComment(CommentUserInputModel commentModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            TaskWrapper.ExecuteFunctionInNewThread(() =>
            {
                try
                {
                    UserStorySearchCriteriaInputModel userStorySearchCriteriaInputModel = new UserStorySearchCriteriaInputModel
                    {
                        UserStoryId = commentModel.ReceiverId
                    };

                    List<UserStoryApiReturnModel> userStories = _userStoryRepository.SearchUserStories(userStorySearchCriteriaInputModel,
                        loggedInContext, new List<ValidationMessage>());

                    if (userStories != null && userStories.Count == 1 &&
                        userStories[0].OwnerUserId != loggedInContext.LoggedInUserId)
                    {
                        List<UserOutputModel> operationPerformedUserDetails = _userRepository.GetAllUsers(
                       new UserSearchCriteriaInputModel
                       {
                           UserId = loggedInContext.LoggedInUserId
                       }, loggedInContext, validationMessages);
                        if (operationPerformedUserDetails != null && operationPerformedUserDetails.Count > 0)
                        {
                            _notificationService.SendNotification(new NotificationModelForUserStoryComment(
                                   string.Format(NotificationSummaryConstants.PushNotificationUserStoryCommentMessage,
                                       operationPerformedUserDetails[0].FirstName + " " +
                                       operationPerformedUserDetails[0].SurName, userStories[0].UserStoryName), userStories[0].UserStoryId,
                                   operationPerformedUserDetails[0].FirstName + " " +
                                       operationPerformedUserDetails[0].SurName, userStories[0].OwnerUserId), loggedInContext, userStories[0].OwnerUserId);
                        }

                        BackgroundJob.Enqueue(() => SendEmailToUserStoryComment(userStories[0], commentModel, loggedInContext,
                            new List<ValidationMessage>()));
                    }

                    AdhocWorkSearchInputModel adhocWorkSearchInputModel = new AdhocWorkSearchInputModel
                    {
                        UserStoryId = commentModel.ReceiverId
                    };

                    GetAdhocWorkOutputModel getAdhocWorkOutputModel = _adhocWorkRepository.SearchAdhocWork(adhocWorkSearchInputModel, loggedInContext, validationMessages).SingleOrDefault();

                    if (getAdhocWorkOutputModel != null)
                    {
                        BackgroundJob.Enqueue(() => SendEmailToAdhocWorkComment(getAdhocWorkOutputModel, commentModel, loggedInContext,
                            new List<ValidationMessage>()));
                    }
                }
                catch (Exception exception)
                {
                    LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProject", "ProjectService ", exception.Message), exception);

                }
            });
        }

        private void SendPushNotificationForaComment(Guid? userStoryId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            TaskWrapper.ExecuteFunctionInNewThread(() =>
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SendPushNotificationForaComment", "Comment Service"));

                List<UserStoryApiReturnModel> userStoryModelList = _userStoryRepository.SearchUserStories(new UserStorySearchCriteriaInputModel() { UserStoryId = userStoryId }, loggedInContext, validationMessages);

                if (userStoryModelList != null && userStoryModelList.Count > 0)
                {
                    var userStoryModel = userStoryModelList[0];

                    if (userStoryModel != null && userStoryModel.OwnerUserId != loggedInContext.LoggedInUserId)
                    {
                        UserOutputModel userDetails = _userService.GetUserById(userStoryModel.OwnerUserId, null, loggedInContext, new List<ValidationMessage>());

                        if (userDetails != null)
                        {
                            if (userStoryModel.OwnerUserId != null)
                                _notificationService.SendPushNotificationsToUser(
                                    new List<Guid?> { userStoryModel.OwnerUserId }, new UserStoryAssignedNotification(
                                        string.Format(
                                            NotificationSummaryConstants.PushNotificationUserStoryCommentMessage,
                                            userStoryModel.UserStoryName, userDetails.FirstName),
                                        loggedInContext.LoggedInUserId,
                                        userStoryModel.OwnerUserId.Value,
                                        userStoryModel.UserStoryId,
                                        userStoryModel.UserStoryName
                                    ));
                        }
                    }
                }
            });
        }

        public List<CommentApiReturnModel> SearchComments(CommentsSearchCriteriaInputModel commentsSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Search Comments", "Comments Service"));

            _auditService.SaveAudit(AppCommandConstants.SearchCommentsCommandId, commentsSearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, commentsSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            List<CommentSpReturnModel> commentSpReturnModels = _commentsRepository.SearchComments(commentsSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            List<CommentApiReturnModel> commentApiReturnModels = new List<CommentApiReturnModel>();

            foreach (var commentSpReturnModel in commentSpReturnModels)
            {
                commentApiReturnModels.Add(ConvertToApiReturnModel(commentSpReturnModel));
            }

            commentApiReturnModels = BuildCommentsTree(commentApiReturnModels).ToList();

            return commentApiReturnModels;
        }

        public CommentApiReturnModel GetCommentById(Guid? commentId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCommentById", "Comment Service"));

            LoggingManager.Debug(commentId.ToString());

            if (!CommentValidations.ValidateCommentById(commentId, loggedInContext, validationMessages))
            {
                return null;
            }

            var commentsSearchCriteriaInputModel = new CommentsSearchCriteriaInputModel
            {
                CommentId = commentId
            };

            CommentSpReturnModel commentSpReturnModel = _commentsRepository.SearchComments(commentsSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();

            if (commentSpReturnModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundCommentWithTheId, commentId)
                });

                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetCommentByIdCommandId, commentsSearchCriteriaInputModel, loggedInContext);

            CommentApiReturnModel commentApiReturnModel = ConvertToApiReturnModel(commentSpReturnModel);

            LoggingManager.Debug(commentApiReturnModel?.ToString());

            return commentApiReturnModel;
        }

        public List<CommentApiReturnModel> GetCommentsByReceiverId(Guid? receiverId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCommentsByReceiverId", "Comment Service"));

            LoggingManager.Debug(receiverId.ToString());

            if (!CommentValidations.ValidateCommentByReceiverId(receiverId, loggedInContext, validationMessages))
            {
                return null;
            }

            var commentsSearchCriteriaInputModel = new CommentsSearchCriteriaInputModel
            {
                ReceiverId = receiverId
            };

            List<CommentSpReturnModel> commentSpReturnModels = _commentsRepository.SearchComments(commentsSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            _auditService.SaveAudit(AppCommandConstants.GetCommentsByReceiverIdCommandId, commentsSearchCriteriaInputModel, loggedInContext);

            List<CommentApiReturnModel> commentApiReturnModels = new List<CommentApiReturnModel>();

            foreach (var commentSpReturnModel in commentSpReturnModels)
            {
                commentApiReturnModels.Add(ConvertToApiReturnModel(commentSpReturnModel));
            }

            return commentApiReturnModels;
        }

        private CommentApiReturnModel ConvertToApiReturnModel(CommentSpReturnModel commentSpReturnModel)
        {
            CommentApiReturnModel commentApiReturnModel = new CommentApiReturnModel
            {
                OriginallyCommentedDateTime = commentSpReturnModel.CreatedDateTime,
                CommentUpdatedDateTime = commentSpReturnModel.UpdatedDateTime,
                Comment = commentSpReturnModel.Comment,
                ReceiverId = commentSpReturnModel.ReceiverId,
                CommentedByUser = new UserMiniModel
                {
                    Id = commentSpReturnModel.CommentedByUserId,
                    Name = commentSpReturnModel.CommentedByUserFullName,
                    ProfileImage = commentSpReturnModel.CommentedByUserProfileImage
                },
                CommentId = commentSpReturnModel.CommentId,
                ParentCommentId = commentSpReturnModel.ParentCommentId,
                CommentedOnObjectId = commentSpReturnModel.ReceiverId
            };

            return commentApiReturnModel;
        }

        public IList<CommentApiReturnModel> BuildCommentsTree(IEnumerable<CommentApiReturnModel> commentApiReturnModels)
        {
            List<IGrouping<Guid?, CommentApiReturnModel>> groupOfCommentApiReturnModels = commentApiReturnModels.GroupBy(i => i.ParentCommentId).ToList();

            IGrouping<Guid?, CommentApiReturnModel> groupFirstOrDefault = groupOfCommentApiReturnModels.FirstOrDefault(g => g.Key.HasValue == false);

            if (groupFirstOrDefault != null)
            {
                List<CommentApiReturnModel> apiReturnModels = groupFirstOrDefault.ToList();

                if (apiReturnModels.Count > 0)
                {
                    Dictionary<Guid, List<CommentApiReturnModel>> dictionary = groupOfCommentApiReturnModels.Where(g => g.Key.HasValue).ToDictionary(g => g.Key.Value, g => g.ToList());

                    foreach (var apiReturnModel in apiReturnModels)
                    {
                        AddChildren(apiReturnModel, dictionary);
                    }
                }

                return apiReturnModels;
            }
            return new List<CommentApiReturnModel>();
        }

        public void SendEmailToUserStoryComment(UserStoryApiReturnModel userStoryApiReturnModel,
            CommentUserInputModel commentModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages)
        {
            List<UserOutputModel> operationPerformedUserDetails = _userRepository.GetAllUsers(
                new UserSearchCriteriaInputModel
                {
                    UserId = loggedInContext.LoggedInUserId
                }, loggedInContext, validationMessages);

            List<UserOutputModel> usersList = _userRepository.GetAllUsers(
                new UserSearchCriteriaInputModel
                {
                    UserId = userStoryApiReturnModel.OwnerUserId
                }, loggedInContext, validationMessages);

            if (usersList != null && usersList.Count > 0 && operationPerformedUserDetails != null && operationPerformedUserDetails.Count > 0)
            {
                CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

                //TODO: Review this code
                var siteDomain = ConfigurationManager.AppSettings["SiteUrl"];

                var siteAddress = siteDomain + "/projects/workitem/" + userStoryApiReturnModel.UserStoryId;
                SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, companyDetails.SiteAddress);

                var softLabelsSearchInputModel = new SoftLabelsSearchInputModel();

                List<SoftLabelApiReturnModel> softLabelsList = _masterDataManagementRepository.GetSoftLabelConfigurations(softLabelsSearchInputModel, loggedInContext, validationMessages).ToList();
                string WorkItemName = "";
                string ProjectUniqueName = "Project name";
                string GoalOrsprintName = "Goal or sprint name";
                string GoalName = "";
                string ProjectName = "";

                string workItemName;

                if (softLabelsList.Count > 0 && !string.IsNullOrEmpty(softLabelsList[0].UserStoryLabel))
                {
                    workItemName = softLabelsList[0].UserStoryLabel;
                }
                else
                {
                    workItemName = "work item";
                }
                if (!string.IsNullOrEmpty(softLabelsList[0].ProjectLabel))
                {
                    ProjectUniqueName = Regex.Replace(ProjectUniqueName, "project", softLabelsList[0].ProjectLabel, RegexOptions.IgnoreCase);
                }
                else
                {
                    ProjectUniqueName = "Project name";
                }
                if (!string.IsNullOrEmpty(softLabelsList[0].GoalLabel))
                {
                    GoalOrsprintName = Regex.Replace(GoalOrsprintName, "goal", softLabelsList[0].GoalLabel, RegexOptions.IgnoreCase);
                }
                else
                {
                    GoalOrsprintName = "Goal or sprint name";
                }
                if (userStoryApiReturnModel.IsFromSprints == true)
                {
                    GoalName = userStoryApiReturnModel.SprintName;
                }
                else
                {
                    GoalName = userStoryApiReturnModel.GoalName;
                }

                var html = _goalRepository.GetHtmlTemplateByName("UserStoryCommentEmailTemplate", loggedInContext.CompanyGuid);

                var formattedHtml = html.Replace("##OperationPerformedUser##", operationPerformedUserDetails[0].FirstName + " " +
                                                                               operationPerformedUserDetails[0].SurName).
                    Replace("##UserStoryName##", userStoryApiReturnModel.UserStoryName).
                    Replace("##UserStoryUniqueName##", userStoryApiReturnModel.UserStoryUniqueName).
                    Replace("##WorkItemName##", WorkItemName).
                    Replace("##ProjectUniqueName##", ProjectUniqueName).
                    Replace("##GoalOrsprintName##", GoalOrsprintName).
                    Replace("##ProjectName##", userStoryApiReturnModel.ProjectName).
                    Replace("##GoalName##", GoalName).
                    Replace("##WorkItemName##", workItemName).
                    Replace("##Comment##", commentModel.Comment).
                    Replace("##siteAddress##", siteAddress);
                EmailGenericModel emailModel = new EmailGenericModel
                {
                    SmtpServer = smtpDetails?.SmtpServer,
                    SmtpServerPort = smtpDetails?.SmtpServerPort,
                    SmtpMail = smtpDetails?.SmtpMail,
                    SmtpPassword = smtpDetails?.SmtpPassword,
                    ToAddresses = new[] { usersList[0].Email },
                    HtmlContent = formattedHtml,
                    Subject = "Snovasys Business Suite: " + operationPerformedUserDetails[0].FirstName + " " + operationPerformedUserDetails[0].SurName + " commented on the " + " " + workItemName + " " + userStoryApiReturnModel.UserStoryUniqueName,
                    CCMails = null,
                    BCCMails = null,
                    MailAttachments = null,
                    IsPdf = null
                };
                _emailService.SendMail(loggedInContext, emailModel);
            }
        }

        public void SendEmailToAdhocWorkComment(GetAdhocWorkOutputModel userStoryApiReturnModel,
            CommentUserInputModel commentModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages)
        {
            List<UserOutputModel> operationPerformedUserDetails = _userRepository.GetAllUsers(
                new UserSearchCriteriaInputModel
                {
                    UserId = loggedInContext.LoggedInUserId
                }, loggedInContext, validationMessages);

            List<UserOutputModel> usersList = _userRepository.GetAllUsers(
                new UserSearchCriteriaInputModel
                {
                    UserId = userStoryApiReturnModel.OwnerUserId
                }, loggedInContext, validationMessages);

            if (usersList != null && usersList.Count > 0 && operationPerformedUserDetails != null && operationPerformedUserDetails.Count > 0)
            {
                CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);
                string WorkItemName = "";
                string ProjectUniqueName = "Project name";
                string GoalOrsprintName = "Goal or sprint name";
                string GoalName = "";
                string ProjectName = "";
                var siteDomain = ConfigurationManager.AppSettings["SiteUrl"];
                var siteAddress = siteDomain + "/projects/workitem/" + userStoryApiReturnModel.UserStoryId;
                SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, companyDetails.SiteAddress);

                var html = _goalRepository.GetHtmlTemplateByName("UserStoryCommentEmailTemplate", loggedInContext.CompanyGuid);
                var softLabelsSearchInputModel = new SoftLabelsSearchInputModel();
                List<SoftLabelApiReturnModel> softLabelsList = _masterDataManagementRepository.GetSoftLabelConfigurations(softLabelsSearchInputModel, loggedInContext, validationMessages).ToList();
                if (softLabelsList.Count > 0 && !string.IsNullOrEmpty(softLabelsList[0].UserStoryLabel))
                {
                    WorkItemName = softLabelsList[0].UserStoryLabel;
                }
                else
                {
                    WorkItemName = "work item";
                }
                if (!string.IsNullOrEmpty(softLabelsList[0].ProjectLabel))
                {
                    ProjectUniqueName = Regex.Replace(ProjectUniqueName, "project", softLabelsList[0].ProjectLabel, RegexOptions.IgnoreCase);
                }
                else
                {
                    ProjectUniqueName = "Project name";
                }
                if (!string.IsNullOrEmpty(softLabelsList[0].GoalLabel))
                {
                    GoalOrsprintName = Regex.Replace(GoalOrsprintName, "goal", softLabelsList[0].GoalLabel, RegexOptions.IgnoreCase);
                }
                else
                {
                    GoalOrsprintName = "Goal or sprint name";
                }

                var formattedHtml = html.Replace("##OperationPerformedUser##", operationPerformedUserDetails[0].FirstName + " " +
                                                                             operationPerformedUserDetails[0].SurName).
                  Replace("##UserStoryName##", userStoryApiReturnModel.UserStoryName).
                  Replace("##UserStoryUniqueName##", userStoryApiReturnModel.UserStoryUniqueName).
                  Replace("##WorkItemName##", WorkItemName).
                  Replace("##ProjectUniqueName##", ProjectUniqueName).
                  Replace("##GoalOrsprintName##", GoalOrsprintName).
                  Replace("##ProjectName##", "Adhoc project").
                  Replace("##GoalName##", "Adhoc goal").
                  Replace("##WorkItemName##", WorkItemName).
                  Replace("##Comment##", commentModel.Comment).
                  Replace("##siteAddress##", siteAddress);
                EmailGenericModel emailModel = new EmailGenericModel
                {
                    SmtpServer = smtpDetails?.SmtpServer,
                    SmtpServerPort = smtpDetails?.SmtpServerPort,
                    SmtpMail = smtpDetails?.SmtpMail,
                    SmtpPassword = smtpDetails?.SmtpPassword,
                    ToAddresses = new[] { usersList[0].Email },
                    HtmlContent = formattedHtml,
                    Subject = "Snovasys Business Suite: " + operationPerformedUserDetails[0].FirstName + " " + operationPerformedUserDetails[0].SurName + " commented on the work item " + userStoryApiReturnModel.UserStoryUniqueName,
                    CCMails = null,
                    BCCMails = null,
                    MailAttachments = null,
                    IsPdf = null
                };
                _emailService.SendMail(loggedInContext, emailModel);
            }
        }

        private void AddChildren(CommentApiReturnModel node, IDictionary<Guid, List<CommentApiReturnModel>> source)
        {
            if (node.CommentId != null && source.ContainsKey(node.CommentId.Value))
            {
                node.ChildComments = source[node.CommentId.Value];

                foreach (var childComment in node.ChildComments)
                {
                    AddChildren(childComment, source);
                }
            }
            else
            {
                node.ChildComments = new List<CommentApiReturnModel>();
            }
        }
    }
}