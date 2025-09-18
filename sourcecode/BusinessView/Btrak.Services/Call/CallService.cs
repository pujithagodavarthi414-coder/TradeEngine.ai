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
using Btrak.Models.Crm.Call;
using System.Threading.Tasks;
using Btrak.Services.CRM;
using Newtonsoft.Json;
using System.IO;
using Btrak.Models.File;
using System.Web;
using Btrak.Services.FileUploadDownload;

namespace Btrak.Services.Comments
{
    public class CallService : ICallService
    {
        private readonly CallRepository _callRepository;
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
        private readonly ITwilioWrapperClientService _iTwilioWrapperClientService;
        private readonly IFileStoreService _fileStoreService;

        public CallService(CallRepository callRepository, IAuditService auditService, INotificationService notificationService, UserStoryRepository userStoryRepository, IUserService userService, ICompanyStructureService companyStructureService,
            GoalRepository goalRepository, UserRepository userRepository, AdhocWorkRepository adhocWorkRepository, MasterDataManagementRepository masterDataManagementRepository,
            IEmailService emailService, ITwilioWrapperClientService iTwilioWrapperClientService,
            IFileStoreService fileStoreService)
        {
            _callRepository = callRepository;
            _auditService = auditService;
            _notificationService = notificationService;
            _userService = userService;
            _companyStructureService = companyStructureService;
            _userRepository = userRepository;
            _adhocWorkRepository = adhocWorkRepository;
            _masterDataManagementRepository = masterDataManagementRepository;
            _iTwilioWrapperClientService = iTwilioWrapperClientService;
            _fileStoreService = fileStoreService;
        }

        public Guid? UpsertCallFeedback(CallFeedbackUserInputModel callFeedbackModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            callFeedbackModel.CallDescription = callFeedbackModel.CallDescription?.Trim();

            if (!CallValidations.ValidateCallFeedbackUpsertInputModel(callFeedbackModel, loggedInContext, validationMessages))
            {
                return null;
            }

            callFeedbackModel.CallFeedbackId = _callRepository.UpsertCallFeedback(callFeedbackModel, loggedInContext, validationMessages);

            LoggingManager.Debug(callFeedbackModel.CallFeedbackId?.ToString());

            Task.Factory.StartNew(() =>
            {
                try
                {
                    if (callFeedbackModel.CallResource != null)
                    {
                        CallResourceModel callResource = JsonConvert.DeserializeObject<CallResourceModel>(callFeedbackModel.CallResource);
                        foreach (KeyValuePair<string, string> entry in callResource.RecordingURLs)
                        {
                            var result = new FileResult();
                            BtrakPostedFile filePostInputModel = new BtrakPostedFile();

                            CompanyOutputModel companyModel = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);
                            Stream fileStream = _iTwilioWrapperClientService.GetStreamFromRecordUrl(entry.Key, entry.Value); ;
                            filePostInputModel.FileName = entry.Key;
                            filePostInputModel.ContentType = "audio/mpeg";
                            filePostInputModel.InputStream = fileStream;

                            result.FileName = entry.Key;
                            result.FilePath = _fileStoreService.UploadFiles(filePostInputModel, companyModel, 0, loggedInContext.LoggedInUserId);
                            result.FileExtension = Path.GetExtension(filePostInputModel.FileName);
                            result.FileSize = fileStream.Length;
                            callFeedbackModel.CallRecordingLink = result.FilePath;
                            callFeedbackModel.CallFeedbackId = _callRepository.UpsertCallFeedback(callFeedbackModel, loggedInContext, validationMessages);
                            _iTwilioWrapperClientService.DeleteRecordingTwilio(entry.Key, entry.Value);
                        }
                    }
                }
                catch (Exception exception)
                {
                    LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExecuteFunctionInNewThread", "TaskWrapperClass", exception.Message), exception);
                }
            });

            _auditService.SaveAudit(AppCommandConstants.UpsertCommentCommandId, callFeedbackModel, loggedInContext);

            //SendPushNotificationForaComment(callFeedbackModel.ReceiverId, loggedInContext, validationMessages);

            return callFeedbackModel.CallFeedbackId;
        }

        private void SendPushNotificationForaComment(Guid? userStoryId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
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
        }

        public List<CallFeedbackApiReturnModel> SearchCallFeedback(CallFeedbackSearchCriteriaInputModel callFeedbackSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Search Comments", "Comments Service"));

            _auditService.SaveAudit(AppCommandConstants.SearchCommentsCommandId, callFeedbackSearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, callFeedbackSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            List<CallFeedbackSpReturnModel> commentSpReturnModels = _callRepository.SearchCallFeedback(callFeedbackSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            List<CallFeedbackApiReturnModel> CallFeedbackApiReturnModels = new List<CallFeedbackApiReturnModel>();

            foreach (var CallFeedbackSpReturnModel in commentSpReturnModels)
            {
                CallFeedbackApiReturnModels.Add(ConvertToApiReturnModel(CallFeedbackSpReturnModel));
            }

            CallFeedbackApiReturnModels = BuildCommentsTree(CallFeedbackApiReturnModels).ToList();

            return CallFeedbackApiReturnModels;
        }

        public CallFeedbackApiReturnModel GetCallFeedbackById(Guid? CallFeedbackId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCommentById", "Comment Service"));

            LoggingManager.Debug(CallFeedbackId.ToString());

            if (!CallValidations.ValidateCommentById(CallFeedbackId, loggedInContext, validationMessages))
            {
                return null;
            }

            var callFeedbackSearchCriteriaInputModel = new CallFeedbackSearchCriteriaInputModel
            {
                CallFeedbackId = CallFeedbackId
            };

            CallFeedbackSpReturnModel CallFeedbackSpReturnModel = _callRepository.SearchCallFeedback(callFeedbackSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();

            if (CallFeedbackSpReturnModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundCommentWithTheId, CallFeedbackId)
                });

                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetCommentByIdCommandId, callFeedbackSearchCriteriaInputModel, loggedInContext);

            CallFeedbackApiReturnModel CallFeedbackApiReturnModel = ConvertToApiReturnModel(CallFeedbackSpReturnModel);

            LoggingManager.Debug(CallFeedbackApiReturnModel?.ToString());

            return CallFeedbackApiReturnModel;
        }

        public List<CallFeedbackApiReturnModel> GetCallFeedbacksByReceiverId(Guid? receiverId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCommentsByReceiverId", "Comment Service"));

            LoggingManager.Debug(receiverId.ToString());

            if (!CallValidations.ValidateCommentByReceiverId(receiverId, loggedInContext, validationMessages))
            {
                return null;
            }

            var callFeedbackSearchCriteriaInputModel = new CallFeedbackSearchCriteriaInputModel
            {
                ReceiverId = receiverId
            };

            List<CallFeedbackSpReturnModel> commentSpReturnModels = _callRepository.SearchCallFeedback(callFeedbackSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            _auditService.SaveAudit(AppCommandConstants.GetCommentsByReceiverIdCommandId, callFeedbackSearchCriteriaInputModel, loggedInContext);

            List<CallFeedbackApiReturnModel> CallFeedbackApiReturnModels = new List<CallFeedbackApiReturnModel>();

            foreach (var CallFeedbackSpReturnModel in commentSpReturnModels)
            {
                CallFeedbackApiReturnModels.Add(ConvertToApiReturnModel(CallFeedbackSpReturnModel));
            }

            return CallFeedbackApiReturnModels;
        }

        private CallFeedbackApiReturnModel ConvertToApiReturnModel(CallFeedbackSpReturnModel callFeedbackSpReturnModel)
        {
            CallFeedbackApiReturnModel CallFeedbackApiReturnModel = new CallFeedbackApiReturnModel
            {
                CallDescription = callFeedbackSpReturnModel.CallDescription,
                CallDuration = callFeedbackSpReturnModel.Duration,
                CallEndedOn = callFeedbackSpReturnModel.CallEndedOn,
                CallFeedbackId = callFeedbackSpReturnModel.CallFeedbackId,
                CallFeedbackOnObjectId = callFeedbackSpReturnModel.ReceiverId,
                CallLoggedDateTime = (callFeedbackSpReturnModel.CallLoggedDate + callFeedbackSpReturnModel.CallLoggedTime),
                CallLogTypeId = callFeedbackSpReturnModel.ActivityTypeId,
                CallLogTypeName = callFeedbackSpReturnModel.ActivityTypeName,
                CallOutcomeCode = callFeedbackSpReturnModel.OutcomeCode,
                CallOutcomeName = callFeedbackSpReturnModel.OutcomeName,
                CallRecordingLink = callFeedbackSpReturnModel.CallRecordingLink,
                CallStartedOn = callFeedbackSpReturnModel.CallStartedOn,
                ReceiverId = callFeedbackSpReturnModel.ReceiverId,
                CallFeedbackByUser = new UserMiniModel
                {
                    Id = callFeedbackSpReturnModel.FeedbackByUserId,
                    Name = callFeedbackSpReturnModel.FeedbackByUserFullName,
                    ProfileImage = callFeedbackSpReturnModel.FeedbackByUserProfileImage
                },
                CreatedDateTime = callFeedbackSpReturnModel.CreatedDateTime
            };

            return CallFeedbackApiReturnModel;
        }

        public IList<CallFeedbackApiReturnModel> BuildCommentsTree(IEnumerable<CallFeedbackApiReturnModel> CallFeedbackApiReturnModels)
        {
            List<IGrouping<Guid?, CallFeedbackApiReturnModel>> groupOfCallFeedbackApiReturnModels = CallFeedbackApiReturnModels.GroupBy(i => i.ParentCallFeedbackId).ToList();

            IGrouping<Guid?, CallFeedbackApiReturnModel> groupFirstOrDefault = groupOfCallFeedbackApiReturnModels.FirstOrDefault(g => g.Key.HasValue == false);

            if (groupFirstOrDefault != null)
            {
                List<CallFeedbackApiReturnModel> apiReturnModels = groupFirstOrDefault.ToList();

                if (apiReturnModels.Count > 0)
                {
                    Dictionary<Guid, List<CallFeedbackApiReturnModel>> dictionary = groupOfCallFeedbackApiReturnModels.Where(g => g.Key.HasValue).ToDictionary(g => g.Key.Value, g => g.ToList());

                    foreach (var apiReturnModel in apiReturnModels)
                    {
                        AddChildren(apiReturnModel, dictionary);
                    }
                }

                return apiReturnModels;
            }
            return new List<CallFeedbackApiReturnModel>();
        }

        private void AddChildren(CallFeedbackApiReturnModel node, IDictionary<Guid, List<CallFeedbackApiReturnModel>> source)
        {
            if (node.CallFeedbackId != null && source.ContainsKey(node.CallFeedbackId.Value))
            {
                node.ChildFeedbacks = source[node.CallFeedbackId.Value];

                foreach (var childComment in node.ChildFeedbacks)
                {
                    AddChildren(childComment, source);
                }
            }
            else
            {
                node.ChildFeedbacks = new List<CallFeedbackApiReturnModel>();
            }
        }

        public List<CallOutcomeModel> GetCallOutcome(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            List<CallOutcomeModel> callOutcomes = _callRepository.GetCallOutcome(loggedInContext, validationMessages);

            return callOutcomes;
        }

        public List<VideoCallLogOutputModel> SearchVideoCallLog(RoomDetailsModel roomDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchVideoCallLog", "Call Service"));

            return _callRepository.SearchVideoCallLog(roomDetails, loggedInContext, validationMessages);
        }
    }
}