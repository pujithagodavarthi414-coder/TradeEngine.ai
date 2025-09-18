
using BusinessView.Api.Models;
using BusinessView.Common;
using BusinessView.DAL;
using BusinessView.Models;
using BusinessView.Services;
using BusinessView.Services.Interfaces;
using Microsoft.AspNet.Identity;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Http;

namespace BusinessView.Api.Controllers.Api
{
    public class UserStoryApiController : ApiController
    {
        private readonly IBlobService _blobService;
        private readonly IFileService _fileService;
        private readonly IAuditService _auditService;
        private readonly IUserStoryService _userStoryService;

        public UserStoryApiController()
        {
            _blobService = new BlobService();
            _fileService = new FileService();
            _auditService = new AuditService();
            _userStoryService = new UserStoryService();
        }

        [HttpPost]
        [Authorize]
        [System.Web.Mvc.ValidateInput(false)]
        public string SaveFile(int userStoryId)
        {
            using (var entities = new BViewEntities())
            {
                var updatedDescription = string.Empty;

                var userId = User.Identity.GetUserId<int>();

                var description = HttpContext.Current.Request.Unvalidated.Form.Get("Description");

                if (!string.IsNullOrEmpty(description))
                {
                    updatedDescription = updatedDescription + description + "</br>";
                }

                int count = Convert.ToInt32(HttpContext.Current.Request.Form["Count"]);

                var userStory = entities.UserStories.FirstOrDefault(x => x.Id == userStoryId);

                for (int i = 0; i < count; i++)
                {
                    var files = HttpContext.Current.Request.Files["Files" + i];

                    if (files != null)
                    {
                        var name = Path.GetFileName(files.FileName);

                        var fileExtension = Path.GetExtension(name);

                        if (files.ContentLength > 0)
                        {
                            var filePath = _blobService.UploadFile(files);
                            var fileName = files.FileName;

                            var file = new FilesModel
                            {
                                FilePath = filePath,
                                FileName = fileName,
                                CreatedOn = DateTime.Now,
                                CreatedBy = userId,
                                UserStoryId = userStoryId,
                            };

                            _fileService.AddOrUpdate(file);

                            var updatedFile = "<li>" + "File " + "<a target='_blank' class='file-link' href='" +
                                              filePath + "'>" + fileName + "</a>" + " added </li>";

                            updatedDescription = updatedDescription + updatedFile;
                        }
                    }
                }

                if (!string.IsNullOrEmpty(updatedDescription))
                {
                    updatedDescription = "<ul>" + updatedDescription + "</ul>";

                    var model = new AuditModel
                    {
                        UserId = userId,
                        ProjectId = userStory.ProjectId,
                        UserStoryId = userStoryId,
                        GoalId = userStory.GoalId,
                        Description = updatedDescription,
                        UpdatedDate = DateTime.Now
                    };

                    _auditService.AddOrUpdate(model);
                }

                return AppConstants.SuccessMessage;
            }
        }

        [HttpPost]
        public string GetGoalsList(int projectId, bool? isApproved)
        {
            using (var entities = new BViewEntities())
            {
                var userId = User.Identity.GetUserId<int>();

                var goals = entities.USP_GetApprovedNotApprovedGoalsList(userId, projectId, isApproved).Select(x => new GoalViewModel
                {
                    GoalId = Convert.ToInt32(x.Id),
                    GoalName = x.GoalName,
                }).ToList();

                return JsonConvert.SerializeObject(goals);
            }
        }

        [HttpPost]
        public string GetUserStory(int goalId)
        {
            using (var entities = new BViewEntities())
            {
                var userStories = entities.USP_GetUserStories(goalId).ToList();

                var model = new ResultViewModel();

                var userStoriesList = new List<UserStoryViewModel>();

                model.Goal = userStories.Select(x => x.GoalName).FirstOrDefault();

                foreach (var userStory in userStories)
                {
                    var userStoryModel = new UserStoryViewModel
                    {
                        Id = Convert.ToInt32(userStory.UserStoryId),
                        UserStory = userStory.UserStoryName,
                        EstimatedTime = userStory.EstimatedTime,
                        ETime = userStory.EstimatedTime != null ? string.Format("{0:G29}", decimal.Parse(userStory.EstimatedTime.ToString())) : null,
                        DeadLine = userStory.ReplannedDate?.ToString("dd-MMM-yyyy"),
                        Owner = userStory.Owner,
                        Dependency = userStory.Dependency,
                        ReplannedDate = userStory.ReplannedDate?.ToString("dd-MMM-yyyy"),
                        Reason = userStory.Reason
                    };

                    userStoriesList.Add(userStoryModel);
                }
                model.UserStories = userStoriesList;

                return JsonConvert.SerializeObject(model);
            }
        }

        [HttpPost]
        public string UpdateUserStory(UserStoryEditViewModel model)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Update User Story", "UserStory Api"));

            try
            {
                ModelState.Remove("UserStory");
                ModelState.Remove("model.Reason");

                if (ModelState.IsValid)
                {
                    var userId = User.Identity.GetUserId<int>();
                    model.UserId = userId;

                    _userStoryService.UpdateUserStory(model, AppConstants.EditUserStory);

                    var userStory = new BusinessViewJsonResult
                    {
                        Success = true
                    };

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update User Story", "UserStory Api"));

                    return JsonConvert.SerializeObject(userStory);
                }

                var result = new BusinessViewJsonResult
                {
                    Success = false,
                    ModelState = ModelState
                };

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update User Story", "UserStory Api"));

                return JsonConvert.SerializeObject(result);
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Update User Story", "Home", ex.Message));

                throw;
            }
        }

        [HttpPost]
        public string SaveSpentTime(UserStorySpentTimeModel model)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Save Spent Time", "UserStory Api"));

            try
            {
                if (ModelState.IsValid)
                {
                    var userId = User.Identity.GetUserId<int>();
                    model.UserId = userId;

                    _userStoryService.SaveSpentTime(model);

                    var userStory = new BusinessViewJsonResult
                    {
                        Success = true
                    };

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Save Spent Time", "UserStory Api"));

                    return JsonConvert.SerializeObject(userStory);
                }

                var result = new BusinessViewJsonResult
                {
                    Success = false,
                    ModelState = ModelState
                };

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Save Spent Time", "UserStory Api"));

                return JsonConvert.SerializeObject(result);
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Update User Story", "Home", ex.Message));

                throw;
            }
        }


        [HttpPost]
        public string UpdateUserStoryStatus(UserStoryEditViewModel model)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Update User Story Status", "UserStory Api"));

            try
            {
                using (var entities = new BViewEntities())
                {
                    ModelState.Remove("model.UserStory");
                    ModelState.Remove("model.Reason");

                    ModelState.Remove("model.IsApproved");
                    var userId = User.Identity.GetUserId<int>();
                    model.UserId = userId;

                    var workflow = entities.GoalWorkFlows.FirstOrDefault(x => x.GoalId == model.GoalId);
                    model.WorkflowId = workflow != null ? (int)workflow.WorkflowId : 0;

                    var userStory = entities.UserStories.First(x => x.Id == model.Id);
                    var oldStatusId = userStory.StatusId;
                    model.ProjectId = userStory.ProjectId;

                    if (model.WorkflowId == (int)Enumerators.WorkflowEnum.SuperAgile)
                    {
                        var record = entities.WorkflowEligibleStatusTransitions
                                .FirstOrDefault(x => x.WorkflowId == model.WorkflowId && x.FromWorkflowStatusId == oldStatusId && x.ToWorkflowStatusId == model.StatusId);

                        if (record != null)
                        {
                            _userStoryService.UpdateUserStoryStatus(model);

                            var result = new BusinessViewJsonResult
                            {
                                Success = true
                            };

                            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update User Story Status", "UserStory Api"));

                            return JsonConvert.SerializeObject(result);
                        }
                        else
                        {
                            ModelState.AddModelError("", "Not eligible transition");

                            var result = new BusinessViewJsonResult
                            {
                                Success = false,
                                ModelState = ModelState
                            };

                            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update User Story Status", "UserStory Api"));

                            return JsonConvert.SerializeObject(result);
                        }
                    }
                    else if (model.WorkflowId == (int)Enumerators.WorkflowEnum.Kanban)
                    {
                        int? eligibleStatusTransitionId;
                        if (model.IsApproved == false)
                        {
                            eligibleStatusTransitionId = 1;
                        }
                        else
                        {
                            eligibleStatusTransitionId = entities.WorkflowEligibleStatusTransitions
                                .Where(x => x.WorkflowId == model.WorkflowId && x.FromWorkflowStatusId == oldStatusId)
                                .Select(x => x.ToWorkflowStatusId).FirstOrDefault();
                        }

                        if (model.StatusId == eligibleStatusTransitionId)
                        {
                            _userStoryService.UpdateUserStoryStatus(model);

                            var result = new BusinessViewJsonResult
                            {
                                Success = true
                            };

                            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update User Story Status", "UserStory Api"));

                            return JsonConvert.SerializeObject(result);
                        }
                        else
                        {
                            ModelState.AddModelError("", "Not eligible transition");

                            var result = new BusinessViewJsonResult
                            {
                                Success = false,
                                ModelState = ModelState
                            };

                            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update User Story Status", "UserStory Api"));

                            return JsonConvert.SerializeObject(result);
                        }
                    }
                    else
                    {
                        throw new NotImplementedException();
                    }
                }
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Update User Story Status", "UserStory Api", ex.Message));

                throw;
            }
        }

        [HttpPost]
        public string SaveUserStory(UserStoryModel model)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Save User Story", "UserStory Api"));

            try
            {
                using (var entities = new BViewEntities())
                {
                    if (model.Type == (int)Enumerators.WorkflowEnum.SuperAgile)
                    {
                        ModelState.Remove("model.EstimatedTime");
                        ModelState.Remove("model.OwnerId");
                    }

                    if (ModelState.IsValid)
                    {
                        var userStories = model.UserStory.Split('\n');

                        if (userStories.Length > 0)
                        {
                            foreach (var userStory in userStories)
                            {
                                if (userStory != string.Empty)
                                {
                                    model.UserStory = userStory;
                                    var userStoryId = _userStoryService.AddOrUpdate(model);
                                    var userStoryName = _userStoryService.GetUserStory(userStoryId);

                                    var userId = User.Identity.GetUserId<int>();

                                    var goalId = _userStoryService.GetGoalId(userStoryId);

                                    var details = entities.USP_GetNames(userId, model.ProjectId, goalId).FirstOrDefault();

                                    if (details != null)
                                    {
                                        var auditModel = new AuditModel()
                                        {
                                            UserId = userId,
                                            ProjectId = model.ProjectId,
                                            GoalId = goalId,
                                            UserStoryId = userStoryId,
                                            FiledName = "New user story added",
                                            Description = "<strong>" + details.Name + "</strong>" + " added new user story- " + userStoryName + " in the project " + details.ProjectName + " for the goal " + details.Goal,
                                            UpdatedDate = DateTime.Now
                                        };

                                        _auditService.AddOrUpdate(auditModel);
                                    }
                                }
                            }
                        }

                        var result1 = new BusinessViewJsonResult
                        {
                            Success = true
                        };

                        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Save User Story", "Home"));

                        return JsonConvert.SerializeObject(result1);
                    }

                    var result = new BusinessViewJsonResult
                    {
                        Success = false,
                        ModelState = ModelState
                    };

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Save User Story", "UserStory Api"));

                    return JsonConvert.SerializeObject(result);
                }
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Add User Story", "UserStory Api", ex.Message));

                throw;
            }
        }

        [HttpPost]
        public string UpdateUserStoryEstimatedTime(UserStoryEditViewModel model)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Update User Story Estimated Time", "UserStory Api"));

            try
            {
                var userStoryId = model.Id;
                var userId = User.Identity.GetUserId<int>();
                model.UserId = userId;

                var details = _userStoryService.ReadItem(userStoryId);

                model.Id = userStoryId;
                model.GoalId = details.GoalId;
                model.ProjectId = details.ProjectId;

                _userStoryService.UpdateUserStoryEstimatedTime(model);

                var userStory = new BusinessViewJsonResult
                {
                    Success = true
                };

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update User Story Estimated Time", "UserStory Api"));

                return JsonConvert.SerializeObject(userStory);
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Update User Story Estimated Time", "UserStory Api", ex.Message));

                throw;
            }
        }

        [HttpPost]
        public string UpdateUserStoryDeadline(UserStoryEditViewModel model)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Update User Story Deadline", "UserStory Api"));

            try
            {
                var userStoryId = model.Id;
                var userId = User.Identity.GetUserId<int>();
                model.UserId = userId;

                var details = _userStoryService.ReadItem(userStoryId);

                model.Id = userStoryId;
                model.GoalId = details.GoalId;
                model.ProjectId = details.ProjectId;

                _userStoryService.UpdateUserStoryDeadline(model);

                var userStory = new BusinessViewJsonResult
                {
                    Success = true
                };

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update User Story Deadline", "UserStory Api"));

                return JsonConvert.SerializeObject(userStory);
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Update User Story Deadline", "UserStory Api", ex.Message));

                throw;
            }
        }

        [HttpPost]
        public string UpdateUserStoryOwner(UserStoryEditViewModel model)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Update User Story Owner", "UserStory Api"));

            try
            {
                var userStoryId = model.Id;
                var userId = User.Identity.GetUserId<int>();

                model.UserId = userId;

                var details = _userStoryService.ReadItem(userStoryId);

                model.Id = userStoryId;
                model.GoalId = details.GoalId;
                model.ProjectId = details.ProjectId;

                _userStoryService.UpdateUserStoryOwner(model);

                var userStory = new BusinessViewJsonResult
                {
                    Success = true
                };

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update User Story Owner", "UserStory Api"));

                return JsonConvert.SerializeObject(userStory);
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Update User Story Owner", "UserStory Api", ex.Message));

                throw;
            }
        }

        [HttpPost]
        public string UpdateUserStoryDependency(UserStoryEditViewModel model)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Update User Story Dependency", "UserStory Api"));

            try
            {
                var userStoryId = model.Id;
                var userId = User.Identity.GetUserId<int>();

                model.UserId = userId;

                var details = _userStoryService.ReadItem(userStoryId);

                model.Id = userStoryId;
                model.GoalId = details.GoalId;
                model.ProjectId = details.ProjectId;

                _userStoryService.UpdateUserStoryDependency(model);

                var userStory = new BusinessViewJsonResult
                {
                    Success = true
                };

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update User Story Dependency", "UserStory Api"));

                return JsonConvert.SerializeObject(userStory);
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Update User Story Dependency", "UserStory Api", ex.Message));

                throw;
            }
        }

        [HttpPost]
        public string GetUserStoriesBasedOnOrder(int projectId, int goalId, int[] userStoryIds, bool? allProjects = null, bool? isApproved = null)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get User Stories Based On Order", "UserStory Api"));

            try
            {
                var userId = User.Identity.GetUserId<int>();

                using (var entities = new BViewEntities())
                {
                    int preference = 1;

                    var existedUserStoryIds = entities.UserStories.Where(x => x.ProjectId == projectId && x.GoalId == goalId).OrderBy(x => x.Order).Select(x => x.Id).ToArray();

                    _userStoryService.GetReorderDetails(existedUserStoryIds, userStoryIds, userId, projectId, goalId);

                    foreach (int id in userStoryIds)
                    {
                        var userStories = entities.UserStories.Find(id);
                        if (userStories != null) userStories.Order = preference;
                        entities.SaveChanges();
                        preference += 1;
                    }
                }

                var userStory = new BusinessViewJsonResult
                {
                    Success = true
                };

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get User Stories Based On Order", "UserStory Api"));

                return JsonConvert.SerializeObject(userStory);
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get User Stories Based On Order", "UserStory Api", ex.Message));

                throw;
            }
        }

        [HttpGet]
        public List<CurrentWorkingUserStoryModel> GetCurrentWorkingUserStory()
        {
            var loggedUserId = User.Identity.GetUserId<int>();
            var userStoriesModels = new List<CurrentWorkingUserStoryModel>();

            using (var bViewEntities = new BViewEntities())
            {
                var userStories = bViewEntities.USP_GetEmployeeCurrentWorkingStories(loggedUserId).OrderBy(x => x.ProjectName).ToList();
                foreach (var userStory in userStories)
                {
                    var userStoriesModel = new CurrentWorkingUserStoryModel
                    {
                        UserName = userStory.FullName,
                        ProjectName = userStory.ProjectName,
                        GoalName = userStory.Goal,
                        UserStory = userStory.UserStory,
                        EstimatedTime = userStory.EstimatedTime.ToString(),
                        UserStoryId = userStory.Id,
                        IsStarted = userStory.IsStarted
                    };

                    var isSingleUserStoryStarted = userStories.Where(x => x.IsStarted == true).ToList();

                    userStoriesModel.IsSingleUserStoryStarted =
                        userStories.Count > 0 && isSingleUserStoryStarted.Count > 0;

                    //var userStoryValue = bViewEntities.UserStoryLogTimes.FirstOrDefault(x => x.UserStoryId == userStory.Id && x.UserId == loggedUserId && x.EndTime == null);
                    //if (userStoryValue != null)
                    //{
                    //    if (userStoryValue.StartTime != null &&
                    //        (userStoryValue.StartTime.Value.Date != DateTime.Now.Date && userStoryValue.EndTime == null))
                    //    {
                    //        userStoriesModel.IsStarted = false;
                    //    }
                    //    else
                    //    {
                    //        userStoriesModel.IsStarted = userStory.IsStarted;
                    //    }
                    //}
                    //else
                    //{
                    //    userStoriesModel.IsStarted = userStory.IsStarted;
                    //}


                    userStoriesModels.Add(userStoriesModel);
                }
            }

            return userStoriesModels;
        }

        [HttpGet]
        public string LogUserStoryTime(int userStoryId, int logTimingId)
        {
            var loggedUserId = User.Identity.GetUserId<int>();
            using (var bViewEntities = new BViewEntities())
            {
                if (logTimingId == 1)
                {
                    var previousStartedUserStories = bViewEntities.UserStoryLogTimes
                        .Where(x => x.UserStoryId != userStoryId && x.UserId == loggedUserId).ToList();
                    if (previousStartedUserStories.Count > 0)
                    {
                        foreach (var previousUserStory in previousStartedUserStories)
                        {
                            previousUserStory.EndTime = DateTime.Now;
                            previousUserStory.IsStarted = false;
                            bViewEntities.SaveChanges();
                        }
                    }
                    var logTime = new UserStoryLogTime
                    {
                        UserStoryId = userStoryId,
                        UserId = loggedUserId,
                        StartTime = DateTime.Now,
                        IsStarted = true
                    };
                    bViewEntities.UserStoryLogTimes.Add(logTime);
                    bViewEntities.SaveChanges();
                    return "started";
                }
                var userStoryIdMax = bViewEntities.UserStoryLogTimes.Where(x => x.UserStoryId == userStoryId).Max(x => x.Id);
                var userStory = bViewEntities.UserStoryLogTimes.FirstOrDefault(x => x.Id == userStoryIdMax && x.UserId == loggedUserId);
                if (userStory != null)
                {
                    userStory.EndTime = DateTime.Now;
                    userStory.IsStarted = false;
                    bViewEntities.SaveChanges();
                }
                return "ended";
            }
        }

        [HttpGet]
        public List<ImminentDeadLine> GetImminentDeadLine(int userId)
        {
            var loggedUserId = User.Identity.GetUserId<int>();

            var imminentDeadLines = new List<ImminentDeadLine>();

            using (BViewEntities bViewEntities = new BViewEntities())
            {
                var deadlinesList = bViewEntities.USP_GetImminentDeadLinesOfAUser(userId).ToList();

                foreach (var deadLine in deadlinesList)
                {
                    var deadLineModel = new ImminentDeadLine
                    {
                        UserName = deadLine.FullName,
                        UserStory = deadLine.UserStory,
                        MaxDeadLine = deadLine.MaxDeadLine?.ToString("dd-MMM-yyyy"),
                        EstimatedTime = deadLine.EstimatedTime != null ? string.Format("{0:G29}", decimal.Parse(deadLine.EstimatedTime.ToString())) : null
                    };
                    imminentDeadLines.Add(deadLineModel);
                }
            }
            return imminentDeadLines;
        }

        [HttpGet]
        public List<CurrentWorkingUserStoryModel> GetMyDependentUserStories()
        {
            var loggedUserId = User.Identity.GetUserId<int>();
            List<CurrentWorkingUserStoryModel> currentWorkingUserStory = new List<CurrentWorkingUserStoryModel>();
            using (BViewEntities bViewEntities = new BViewEntities())
            {
                var deadlinesList = bViewEntities.USP_GetUserDependentUserstories(loggedUserId).ToList();
                foreach (var deadLine in deadlinesList)
                {
                    CurrentWorkingUserStoryModel currentWorking = new CurrentWorkingUserStoryModel
                    {
                        GoalName = deadLine.Goal,
                        UserStory = deadLine.UserStory,
                        ProjectName = deadLine.ProjectName
                    };
                    currentWorkingUserStory.Add(currentWorking);
                }
            }
            return currentWorkingUserStory;
        }

        [HttpGet]
        public List<CurrentWorkingUserStoryModel> GetOtherDependentUserStories()
        {
            var loggedUserId = User.Identity.GetUserId<int>();
            List<CurrentWorkingUserStoryModel> dependentUserStoryModel = new List<CurrentWorkingUserStoryModel>();
            using (BViewEntities bViewEntities = new BViewEntities())
            {
                var otherDependenciesList = bViewEntities.USP_GetUserStoriesHavingOtherDependencies(loggedUserId).ToList();
                foreach (var otherDependencies in otherDependenciesList)
                {
                    CurrentWorkingUserStoryModel dependentUserStory = new CurrentWorkingUserStoryModel
                    {
                        GoalName = otherDependencies.Goal,
                        UserStory = otherDependencies.UserStory,
                        ProjectName = otherDependencies.ProjectName,
                        Dependency = otherDependencies.Dependency
                    };
                    dependentUserStoryModel.Add(dependentUserStory);
                }
            }
            return dependentUserStoryModel;
        }

        [HttpGet]
        public List<WorkAllocatedModel> GetWorkAllocated()
        {
            var loggedUserId = User.Identity.GetUserId<int>();
            List<WorkAllocatedModel> userStoriesModels = new List<WorkAllocatedModel>();
            using (BViewEntities bViewEntities = new BViewEntities())
            {
                var userStories = bViewEntities.USP_GetEmployeeAllocatedWorkForAMonth(DateTime.Now.Date, loggedUserId).ToList();
                foreach (var userStory in userStories)
                {
                    WorkAllocatedModel userStoriesModel = new WorkAllocatedModel
                    {
                        UserName = userStory.FullName,
                        AllocatedTime = userStory.MaxAllocatedHours,
                        DeadLineDate = userStory.MaxDeadLine?.ToString("dd-MMM-yyyy")
                    };
                    userStoriesModels.Add(userStoriesModel);
                }
            }
            return userStoriesModels;
        }

        [HttpGet]
        public List<UserStoriesModel> GetUserStoriesBasedOnStatus(int userId, int type)
        {
            var loggedUserId = User.Identity.GetUserId<int>();

            var currentUserStories = new List<UserStoriesModel>();

            using (var bViewEntities = new BViewEntities())
            {
                var results = bViewEntities.USP_GetEmployeeUserStoriesBasedOnStatus(userId, type).ToList();

                foreach (var result in results)
                {
                    var model = new UserStoriesModel
                    {
                        UserName = result.FullName,
                        UserStory = result.UserStory,
                        EstimatedTime = result.EstimatedTime != null ? string.Format("{0:G29}", decimal.Parse(result.EstimatedTime.ToString())) : null
                    };

                    currentUserStories.Add(model);
                }
            }

            return currentUserStories;
        }

        [HttpGet]
        public List<UserStoriesModel> GetPreviousUserStories()
        {
            var loggedUserId = User.Identity.GetUserId<int>();

            var currentUserStories = new List<UserStoriesModel>();

            using (BViewEntities bViewEntities = new BViewEntities())
            {
                var results = bViewEntities.USP_GetImminentDeadLinesOfAUser(loggedUserId).ToList();

                foreach (var result in results)
                {
                    var model = new UserStoriesModel
                    {
                        UserName = result.FullName,
                        UserStory = result.UserStory,
                        DeadLine = result.MaxDeadLine?.ToString("dd-MMM-yyyy"),
                        EstimatedTime = ""
                    };

                    currentUserStories.Add(model);
                }
            }

            return currentUserStories;
        }

        [HttpGet]
        public List<UserStoriesModel> GetNextUserStories()
        {
            var loggedUserId = User.Identity.GetUserId<int>();

            var currentUserStories = new List<UserStoriesModel>();

            using (BViewEntities bViewEntities = new BViewEntities())
            {
                var results = bViewEntities.USP_GetImminentDeadLinesOfAUser(loggedUserId).ToList();

                foreach (var result in results)
                {
                    var model = new UserStoriesModel
                    {
                        UserName = result.FullName,
                        UserStory = result.UserStory,
                        DeadLine = result.MaxDeadLine?.ToString("dd-MMM-yyyy"),
                        EstimatedTime = ""
                    };

                    currentUserStories.Add(model);
                }
            }

            return currentUserStories;
        }
    }
}
