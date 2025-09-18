using System;
using System.Collections.Generic;
using System.Linq;
using Btrak.Dapper.Dal.Repositories;
using BTrak.Common;
using Newtonsoft.Json;
using Btrak.Models;
using Btrak.Models.UserStory;
using Btrak.Services.Audit;
using Btrak.Models.Goals;
using Btrak.Services.Helpers.UserStory;
using Btrak.Services.Helpers.UserStoryValidationHelpers;
using BTrak.Common.Texts;
using System.Globalization;
using Btrak.Models.Sprints;

namespace Btrak.Services.UserStory
{
    public class UserStoryReplanService : IUserStoryReplanService
    {
        private readonly UserStoryReplanRepository _userStoryReplanRepository;
        private readonly IUserStoryService _userStoryService;
        private readonly IAuditService _auditService;

        public UserStoryReplanService(UserStoryReplanRepository userStoryReplanRepository, IUserStoryService userStoryService, IAuditService auditService)
        {
            _userStoryReplanRepository = userStoryReplanRepository;
            _userStoryService = userStoryService;
            _auditService = auditService;
        }

        public Guid? InsertUserStoryReplan(UserStoryReplanUpsertInputModel userStoryReplanUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "InsertUserStoryReplan", "UserStoryReplan Service"));

            LoggingManager.Debug(userStoryReplanUpsertInputModel.ToString());

            if (userStoryReplanUpsertInputModel.UserStoryId == Guid.Empty || userStoryReplanUpsertInputModel.UserStoryId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserStoryId
                });
                return null;
            }

            if (userStoryReplanUpsertInputModel.UserStoryReplanTypeId == Guid.Empty || userStoryReplanUpsertInputModel.UserStoryReplanTypeId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserStoryReplanTypeId
                });
                return null;
            }

            if (validationMessages.Count > 0)
                return null;

            UserStoryApiReturnModel userStoryApiReturnModel = _userStoryService.GetUserStoryById(userStoryReplanUpsertInputModel.UserStoryId, null, loggedInContext, validationMessages);

            if (!UserStoryValidationHelper.ValidateUserStoryFoundWithId(userStoryReplanUpsertInputModel.UserStoryId, validationMessages, userStoryApiReturnModel))
            {
                return null;
            }

            string xml = Utilities.GetXmlFromObject(userStoryApiReturnModel);
            

            if (userStoryReplanUpsertInputModel.EstimatedTime != null)
            {
                var userStoryReplanChangeEstimatedTime = new UserStoryReplanChangeEstimatedTime
                {
                    UserStoryId = userStoryReplanUpsertInputModel.UserStoryId,
                    OldEstimatedTime = userStoryApiReturnModel.EstimatedTime,
                    NewEstimatedTime = userStoryReplanUpsertInputModel.EstimatedTime
                };
                userStoryReplanUpsertInputModel.UserStoryReplanJson = JsonConvert.SerializeObject(userStoryReplanChangeEstimatedTime);
            }
            else if (userStoryReplanUpsertInputModel.UserStoryName != null)
            {
                var userStoryReplanChangeUserStory = new UserStoryReplanChangeUserStory
                {
                    UserStoryId = userStoryReplanUpsertInputModel.UserStoryId,
                    OldUserStory = userStoryApiReturnModel.UserStoryName,
                    NewUserStory = userStoryReplanUpsertInputModel.UserStoryName
                };
                userStoryReplanUpsertInputModel.UserStoryReplanJson = JsonConvert.SerializeObject(userStoryReplanChangeUserStory);
            }
            else if (userStoryReplanUpsertInputModel.UserStoryDeadLine != null)
            {
                var userStoryReplanChangeDeadLine = new UserStoryReplanChangeDeadLine
                {
                    UserStoryId = userStoryReplanUpsertInputModel.UserStoryId,
                    OldDeadLine = userStoryApiReturnModel.DeadLineDate,
                    NewDeadLine = userStoryReplanUpsertInputModel.UserStoryDeadLine
                };
                userStoryReplanUpsertInputModel.UserStoryReplanJson = JsonConvert.SerializeObject(userStoryReplanChangeDeadLine);
            }
            else if (userStoryReplanUpsertInputModel.UserStoryOwnerId != null)
            {
                var userStoryReplanChangeOwner = new UserStoryReplanChangeOwner
                {
                    UserStoryId = userStoryReplanUpsertInputModel.UserStoryId,
                    ExistedOwner = userStoryApiReturnModel.OwnerUserId,
                    NewOwner = userStoryReplanUpsertInputModel.UserStoryOwnerId
                };
                userStoryReplanUpsertInputModel.UserStoryReplanJson = JsonConvert.SerializeObject(userStoryReplanChangeOwner);
            }
            else if (userStoryReplanUpsertInputModel.UserStoryDependencyId != null)
            {
                var userStoryReplanChangeDependency = new UserStoryReplanChangeDependency
                {
                    UserStoryId = userStoryReplanUpsertInputModel.UserStoryId,
                    ExistedDependency = userStoryApiReturnModel.DependencyUserId,
                    NewDependency = userStoryReplanUpsertInputModel.UserStoryDependencyId
                };
                userStoryReplanUpsertInputModel.UserStoryReplanJson = JsonConvert.SerializeObject(userStoryReplanChangeDependency);
            }

            if (string.IsNullOrEmpty(userStoryReplanUpsertInputModel.UserStoryReplanJson))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserStoryReplanJson
                });
                return null;
            }

            if (userStoryReplanUpsertInputModel.UserStoryReplanId == Guid.Empty || userStoryReplanUpsertInputModel.UserStoryReplanId == null)
            {
                userStoryReplanUpsertInputModel.UserStoryReplanId = _userStoryReplanRepository.InsertUserStoryReplan(userStoryReplanUpsertInputModel, loggedInContext, validationMessages);

                if (userStoryReplanUpsertInputModel.UserStoryReplanId != null && userStoryReplanUpsertInputModel.UserStoryReplanId != Guid.Empty)
                {
                    LoggingManager.Debug("New user story replan with the id " + userStoryReplanUpsertInputModel.UserStoryReplanId + " has been created.");

                    _auditService.SaveAudit(AppCommandConstants.InsertUserStoryReplanCommandId, userStoryReplanUpsertInputModel, loggedInContext);

                    return userStoryReplanUpsertInputModel.UserStoryReplanId;
                }

                throw new Exception(ValidationMessages.ExceptionUserStoryReplanCouldNotBeCreated);
            }

            return null;
        }

        public List<GoalReplanHistoryApiReturnModel> GoalReplanHistory(GoalSearchCriteriaInputModel goalSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GoalReplanHistory", "UserStoryReplan Service"));

            if (!UserStoryReplanValidations.ValidateGoalReplanHistory(loggedInContext, validationMessages, goalSearchCriteriaInputModel))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GoalReplanHistoryCommandId, goalSearchCriteriaInputModel, loggedInContext);

            List<GoalReplanHistoryApiReturnModel> goalReplanHistoryReturnModels = _userStoryReplanRepository.GoalReplanHistory(goalSearchCriteriaInputModel, loggedInContext, validationMessages);

            return goalReplanHistoryReturnModels;
        }

        public List<Guid?> UpsertUserStoryReplan(UserStoryReplanInputModel userStoryReplanInputModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue,"UpsertUserStoryReplan", "UserStoryReplan Service"));

            LoggingManager.Debug(userStoryReplanInputModel.ToString());

            if (userStoryReplanInputModel.DeadLine != null)
            {
                string Offset = TimeZoneHelper.GetDefaultTimeZones().FirstOrDefault((p) => p.OffsetMinutes == userStoryReplanInputModel.TimeZoneOffset).GMTOffset;

                userStoryReplanInputModel.UserStoryDeadLine = DateTimeOffset.ParseExact(userStoryReplanInputModel.DeadLine.Value.ToString("yyyy-MM-dd'T'HH:mm:ss") + Offset.Substring(0, 3) + ":" + Offset.Substring(4, 2), "yyyy-MM-dd'T'HH:mm:sszzz", CultureInfo.InvariantCulture);
            }
            if (userStoryReplanInputModel.UserStoryStartDate != null)
            {
                string Offset = TimeZoneHelper.GetDefaultTimeZones().FirstOrDefault((p) => p.OffsetMinutes == userStoryReplanInputModel.TimeZoneOffset).GMTOffset;

                userStoryReplanInputModel.UserStoryStartDate = DateTimeOffset.ParseExact(userStoryReplanInputModel.UserStoryStartDate.Value.ToString("yyyy-MM-dd'T'HH:mm:ss") + Offset.Substring(0, 3) + ":" + Offset.Substring(4, 2), "yyyy-MM-dd'T'HH:mm:sszzz", CultureInfo.InvariantCulture);
            }

            if (userStoryReplanInputModel.UserStoryId == Guid.Empty || userStoryReplanInputModel.UserStoryId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserStoryId
                });
                return null;
            }
           
            if (userStoryReplanInputModel.UserStoryReplanTypeId == Guid.Empty || userStoryReplanInputModel.UserStoryReplanTypeId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserStoryReplanTypeId
                });
                return null;
            }

            if (validationMessages.Count > 0)
                return null;

            UserStoryApiReturnModel userStoryApiReturnModel = new UserStoryApiReturnModel();
            SprintSearchOutPutModel userStoryApiOutPutModel = new SprintSearchOutPutModel();

            if (userStoryReplanInputModel.IsFromSprint == true)
            {
                userStoryApiOutPutModel = _userStoryService.GetSprintUserStoryById(userStoryReplanInputModel.UserStoryId, null, loggedInContext, validationMessages);
            } else
            {
                 userStoryApiReturnModel = _userStoryService.GetUserStoryById(userStoryReplanInputModel.UserStoryId, null, loggedInContext, validationMessages);
            }

            List<UserStoryReplanChangedValues> replanList = new List<UserStoryReplanChangedValues>();

            if (userStoryReplanInputModel.EstimatedTime != null && (userStoryReplanInputModel.IsFromSprint == false || userStoryReplanInputModel.IsFromSprint == null))
            {
              
                var estimatedChanged = new UserStoryReplanChangedValues
                {
                    OldValue = userStoryApiReturnModel.EstimatedTime,
                    NewValue = userStoryReplanInputModel.EstimatedTime,
                    UserStoryId = userStoryReplanInputModel.UserStoryId,
                    UserStoryReplanTypeId = userStoryReplanInputModel.UserStoryReplanTypeId
                };
                if (estimatedChanged.OldValue != estimatedChanged.NewValue)
                    replanList.Add(estimatedChanged);
            }
            else if (userStoryReplanInputModel.EstimatedTime != null && (userStoryReplanInputModel.IsFromSprint == true))
            {
                var estimatedChanged = new UserStoryReplanChangedValues
                {
                    OldValue = userStoryApiOutPutModel.EstimatedTime,
                    NewValue = userStoryReplanInputModel.EstimatedTime,
                    UserStoryId = userStoryReplanInputModel.UserStoryId,
                    UserStoryReplanTypeId = userStoryReplanInputModel.UserStoryReplanTypeId
                };
                if(estimatedChanged.OldValue != estimatedChanged.NewValue)
                replanList.Add(estimatedChanged);
            }
            else if (userStoryReplanInputModel.SprintEstimatedTime != null)
            {
                var sprintEstimatedTimeChanged = new UserStoryReplanChangedValues
                {
                    OldValue = userStoryApiOutPutModel.SprintEstimatedTime,
                    NewValue = userStoryReplanInputModel.SprintEstimatedTime,
                    UserStoryId = userStoryReplanInputModel.UserStoryId,
                    UserStoryReplanTypeId = userStoryReplanInputModel.UserStoryReplanTypeId
                };
                if(sprintEstimatedTimeChanged.OldValue != sprintEstimatedTimeChanged.NewValue)
                replanList.Add(sprintEstimatedTimeChanged);
            }
            else if(userStoryReplanInputModel.UserStoryDeadLine != null)
            {

                var deadLineChanged = new UserStoryReplanChangedValues
                {
                    OldValue = userStoryApiReturnModel.DeadLineDate?.ToString("dd-MM-yyyy"),
                    NewValue = userStoryReplanInputModel.UserStoryDeadLine?.ToString("dd-MM-yyyy"),
                    UserStoryId = userStoryReplanInputModel.UserStoryId,
                    UserStoryReplanTypeId = userStoryReplanInputModel.UserStoryReplanTypeId,
                    
                };
                if(deadLineChanged.OldValue != deadLineChanged.NewValue)
                replanList.Add(deadLineChanged);
            }
            else if (userStoryReplanInputModel.UserStoryStartDate != null)
            {

                var startDateChanged = new UserStoryReplanChangedValues
                {
                    OldValue = userStoryApiReturnModel.UserStoryStartDate?.ToString("dd-MM-yyyy"),
                    NewValue = userStoryReplanInputModel.UserStoryStartDate?.ToString("dd-MM-yyyy"),
                    UserStoryId = userStoryReplanInputModel.UserStoryId,
                    UserStoryReplanTypeId = userStoryReplanInputModel.UserStoryReplanTypeId,

                };
                if (startDateChanged.OldValue != startDateChanged.NewValue)
                    replanList.Add(startDateChanged);
            }
            else if (userStoryReplanInputModel.UserStoryOwnerId != null)
            {
                var ownerChanged = new UserStoryReplanChangedValues
                {
                    OldValue = userStoryApiReturnModel.OwnerUserId,
                    NewValue = userStoryReplanInputModel.UserStoryOwnerId,
                    UserStoryId = userStoryReplanInputModel.UserStoryId,
                    UserStoryReplanTypeId = userStoryReplanInputModel.UserStoryReplanTypeId
                };
                if(ownerChanged.OldValue != ownerChanged.NewValue)
                replanList.Add(ownerChanged);
            }
            else if (userStoryReplanInputModel.UserStoryDependencyId != null)
            {
                var dependencyChanged = new UserStoryReplanChangedValues
                {
                    OldValue = userStoryApiReturnModel.DependencyUserId,
                    NewValue = userStoryReplanInputModel.UserStoryDependencyId,
                    UserStoryId = userStoryReplanInputModel.UserStoryId,
                    UserStoryReplanTypeId = userStoryReplanInputModel.UserStoryReplanTypeId
                };
                if(dependencyChanged.OldValue != dependencyChanged.NewValue)
                replanList.Add(dependencyChanged);
            }
            else if (userStoryReplanInputModel.UserStoryName != null)
            {
                var nameChanged = new UserStoryReplanChangedValues
                {
                    OldValue = userStoryApiReturnModel.UserStoryName,
                    NewValue = userStoryReplanInputModel.UserStoryName,
                    UserStoryId = userStoryReplanInputModel.UserStoryId,
                    UserStoryReplanTypeId = userStoryReplanInputModel.UserStoryReplanTypeId
                };
               
                replanList.Add(nameChanged);
            }

            else if (userStoryReplanInputModel.UserStoryIds != null)
            {
                foreach (Guid? userStoryId in userStoryReplanInputModel.UserStoryIds)
                {
                    UserStoryApiReturnModel userStoryReturnModel = _userStoryService.GetUserStoryById(userStoryId, null, loggedInContext, validationMessages);
                    var ownerChanged = new UserStoryReplanChangedValues
                    {
                        OldValue = userStoryReturnModel.OwnerUserId,
                        NewValue = userStoryReplanInputModel.UserId,
                        UserStoryId = userStoryId,
                        UserStoryReplanTypeId = userStoryReplanInputModel.UserStoryReplanTypeId
                    };
                    replanList.Add(ownerChanged);
                }
              
            }
            userStoryReplanInputModel.UserStoryReplanXML= Utilities.ConvertIntoListXml(replanList);

            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                userStoryReplanInputModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (userStoryReplanInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                userStoryReplanInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }

            List<Guid?> replanIds = _userStoryReplanRepository.UpsertUserStoryReplan(userStoryReplanInputModel, loggedInContext, validationMessages);

            return replanIds;
        }

        public List<GoalReplanHistoryOutputModel> GetGoalReplanHistory(Guid? goalId,int? goalReplanValue, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GoalReplanHistory", "UserStoryReplan Service"));

            if (goalId == Guid.Empty || goalId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyGoalId
                });
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GoalReplanHistoryCommandId, goalId, loggedInContext);

            List<GoalReplanHistorySearchOutputModel> goalReplanHistorySearchOutputModels = _userStoryReplanRepository.GetGoalReplanHistory(goalId, goalReplanValue, loggedInContext, validationMessages);

            //List<GoalReplanHistoryOutputModel> goalReplanModel = goalReplanHistorySearchOutputModels.Select(ConvertingIntoModel).toList()
            List<GoalReplanHistoryOutputModel> goalReplanHistoryOutput = new List<GoalReplanHistoryOutputModel>();
            goalReplanHistoryOutput.Add(ConvertingIntoModel(goalReplanHistorySearchOutputModels));

            return goalReplanHistoryOutput;
        }

        public List<GoalReplanHistoryOutputModel> GetSprintReplanHistory(Guid? sprintId, int? goalReplanValue, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSprintReplanHistory", "UserStoryReplan Service"));

            if (sprintId == Guid.Empty || sprintId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptySprintId
                });
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GoalReplanHistoryCommandId, sprintId, loggedInContext);

            List<GoalReplanHistorySearchOutputModel> goalReplanHistorySearchOutputModels = _userStoryReplanRepository.GetSprintReplanHistory(sprintId, goalReplanValue, loggedInContext, validationMessages);

            //List<GoalReplanHistoryOutputModel> goalReplanModel = goalReplanHistorySearchOutputModels.Select(ConvertingIntoModel).toList()
            List<GoalReplanHistoryOutputModel> goalReplanHistoryOutput = new List<GoalReplanHistoryOutputModel>();
            goalReplanHistoryOutput.Add(ConvertingIntoModel(goalReplanHistorySearchOutputModels));

            return goalReplanHistoryOutput;
        }


        public static GoalReplanHistoryOutputModel ConvertingIntoModel(List<GoalReplanHistorySearchOutputModel> goalReplanHistorySearchOutputModels)
        {

            GoalReplanHistoryOutputModel goalReplanHistoryOutputModel = new GoalReplanHistoryOutputModel
            {
                GoalName = string.Empty,
                TimeZoneName = string.Empty,
                TimeZoneAbbreviation = string.Empty,
                SprintName = string.Empty,
                DateOfReplan = new DateTimeOffset(),
                GoalMembers = string.Empty,
                SprintMembers = string.Empty,
                RequestedBy = string.Empty,
                GoalReplanName = string.Empty,
                SprintReplanName = string.Empty,
                UserStoriesDescrptions = new List<UserStoriesDescrption>(),
                ApprovedUser = string.Empty,
                ApprovedUserId = Guid.Empty,
                GoalReplanCount = new int(),
                SprintReplanCount = new int(),
                MaxReplanCount = new int(),
                GoalReplanId = new Guid(),
                SprintReplanId = new Guid(),
                GoalDelay = new int(),
                SprintDelay = new int()
            };
            
            var goalReplans = from goal in goalReplanHistorySearchOutputModels group goal by goal.UserStoryId;

            foreach (var golGoalReplan in goalReplans)
            {
                UserStoriesDescrption userStoriesDescrption = new UserStoriesDescrption
                {
                    Description = new List<string>(),
                    UserStoryName = string.Empty,
                    UserStoryDelay = new int(),
                    UserStoryUniqueName = string.Empty
                };

                foreach (var goalReplan in golGoalReplan)
                    {
                        goalReplanHistoryOutputModel.GoalName = goalReplan.GoalName;
                        goalReplanHistoryOutputModel.SprintName = goalReplan.SprintName;
                        goalReplanHistoryOutputModel.DateOfReplan = goalReplan.DateOfReplan;
                        goalReplanHistoryOutputModel.GoalMembers = goalReplan.GoalMembers;
                        goalReplanHistoryOutputModel.SprintMembers = goalReplan.SprintMembers;
                        goalReplanHistoryOutputModel.RequestedBy = goalReplan.RequestedBy;
                        goalReplanHistoryOutputModel.GoalReplanName = goalReplan.GoalReplanName;
                        goalReplanHistoryOutputModel.SprintReplanName = goalReplan.SprintReplanName;
                        goalReplanHistoryOutputModel.ApprovedUserId = goalReplan.ApprovedUserId;
                        goalReplanHistoryOutputModel.ApprovedUser = goalReplan.ApprovedUser;
                        goalReplanHistoryOutputModel.GoalReplanCount = goalReplan.GoalReplanCount;
                        goalReplanHistoryOutputModel.SprintReplanCount = goalReplan.SprintReplanCount;
                        goalReplanHistoryOutputModel.MaxReplanCount = goalReplan.MaxReplanCount;
                        goalReplanHistoryOutputModel.GoalReplanId = goalReplan.GoalReplanId;
                        goalReplanHistoryOutputModel.SprintReplanId = goalReplan.SprintReplanId;
                        goalReplanHistoryOutputModel.GoalDelay = goalReplan.GoalDelay;
                        goalReplanHistoryOutputModel.SprintDelay = goalReplan.SprintDelay;
                        goalReplanHistoryOutputModel.TimeZoneName = goalReplan.TimeZoneName;
                        goalReplanHistoryOutputModel.TimeZoneAbbreviation = goalReplan.TimeZoneAbbreviation;

                    if (goalReplan.OldValue == "")
                    {
                        goalReplan.OldValue = "none";
                    }
                    if (golGoalReplan.Key != null)
                    {
                        
                        if (goalReplan.UserStoryId != null)
                        {
                            if (goalReplan.Description.Equals("UserStoryAdd"))
                            {
                                userStoriesDescrption.Description.Add(string.Format(GetPropValue(goalReplan.Description), goalReplan.UserStoryName));
                            }
                            else if(goalReplan.Description.Equals("UserStoryUpdate"))
                            {
                                userStoriesDescrption.Description.Add(string.Format(GetPropValue(goalReplan.Description), goalReplan.UserStoryName));
                            }

                            else
                            {
                                userStoriesDescrption.Description.Add(string.Format(GetPropValue(goalReplan.Description), goalReplan.OldValue, goalReplan.NewValue));
                            }

                            userStoriesDescrption.UserStoryDelay = goalReplan.UserStoryDelay;
                            userStoriesDescrption.UserStoryName = goalReplan.UserStoryName;
                            userStoriesDescrption.UserStoryUniqueName = goalReplan.UserStoryUniqueName;
                        }
                        else
                        {
                            userStoriesDescrption = null;
                        }

                    }                   
                }
                goalReplanHistoryOutputModel.UserStoriesDescrptions.Add(userStoriesDescrption);

            }
            return goalReplanHistoryOutputModel;
        }

        private static string GetPropValue(string propName)
        {
            object src = new LangText();
            return src.GetType().GetProperty(propName)?.GetValue(src, null).ToString();
        }
    }
}
