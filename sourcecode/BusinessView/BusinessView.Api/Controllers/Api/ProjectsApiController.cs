
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
using System.Linq;
using System.Threading.Tasks;
using System.Web.Http;

namespace BusinessView.Api.Controllers.Api
{
    public class ProjectsApiController : ApiController
    {
        private readonly IUserService _userService;
        private readonly IAuditService _auditService;
        private readonly IProjectService _projectService;
        private readonly IUserProjectService _userProjectService;
        private readonly IGoalService _goalService;
        private readonly IUserStoryService _userStoryService;

        public ProjectsApiController()
        {
            _userService = new UserService();
            _auditService = new AuditService();
            _projectService = new ProjectService();
            _userProjectService = new UserProjectService();
            _goalService = new GoalService();
            _userStoryService = new UserStoryService();
        }

        public List<ProjectModel> Get()
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get All Projects", "Projects Api"));

            List<ProjectModel> projectsList;

            try
            {
                projectsList = _projectService.GetAllProjects();
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get All Projects", "Projects Api", ex.Message));

                throw;
            }

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get All Projects", "Projects Api"));

            return projectsList;
        }

        public ProjectModel Get(int id)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Project", "Projects Api"));

            ProjectModel user;

            try
            {
                user = _projectService.GetProject(id);
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get Project", "Projects Api", ex.Message));

                throw;
            }

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Project", "Projects Api"));

            return user;
        }

        [HttpPost]
        public string AddProject(ProjectModel model)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Add Project", "Projects Api"));

            var loggedUserId = User.Identity.GetUserId<int>();
            var loggedUserName = _userService.GetUserName(loggedUserId);

            var userId = loggedUserId.ToString();
            var teamLeadId = model.TeamLeadId?.ToString();

            if (ModelState.IsValid)
            {
                if (_projectService.CheckProjectExists(model))
                {
                    ModelState.AddModelError("ProjectName", "Project name already exists.");

                    var result = new BusinessViewJsonResult
                    {
                        Success = false,
                        ModelState = ModelState
                    };

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add Project", "Projects Api"));

                    return JsonConvert.SerializeObject(result);
                }

                var projectId = _projectService.AddOrUpdate(model);
                var projectName = _projectService.GetProjectName(projectId);

                var userIds = model.UserIds?.ToList();

                if (userIds == null)
                {
                    var usersList = new List<string> { userId };

                    userIds = usersList;
                }
                else
                {
                    userIds.Add(userId);
                }

                if (teamLeadId != null)
                    userIds.Add(teamLeadId);

                if (userIds != null && userIds.Any())
                {
                    if (userIds[0] != null)
                    {
                        var selectedUserIds = userIds;

                        foreach (var selectedUserId in selectedUserIds)
                        {
                            var userProject = new UserProjectModel
                            {
                                UserId = Convert.ToInt32(selectedUserId),
                                ProjectId = projectId,
                            };

                            _userProjectService.AddOrUpdate(userProject);
                        }
                    }
                }

                var auditModel = new AuditModel()
                {
                    UserId = loggedUserId,
                    ProjectId = projectId,
                    FiledName = "New project added",
                    Description = "<strong>" + loggedUserName + "</strong>" + " added new project " + projectName,
                    UpdatedDate = DateTime.Now
                };

                _auditService.AddOrUpdate(auditModel);

                var result1 = new BusinessViewJsonResult
                {
                    Success = true,
                };

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add Project", "Projects Api"));

                return JsonConvert.SerializeObject(result1);
            }

            var result2 = new BusinessViewJsonResult
            {
                Success = false,
                ModelState = ModelState
            };

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add Project", "Projects Api"));

            return JsonConvert.SerializeObject(result2);
        }

        [HttpPut]
        public string UpdateProject(ProjectModel model)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Update Project", "Projects Api"));

            var loggedUserId = User.Identity.GetUserId<int>();
            var loggedUserName = _userService.GetUserName(loggedUserId);

            var userId = loggedUserId.ToString();
            var teamLeadId = model.TeamLeadId?.ToString();

            if (ModelState.IsValid)
            {
                if (_projectService.CheckProjectExists(model))
                {
                    ModelState.AddModelError("ProjectName", "Project name already exists.");

                    var result = new BusinessViewJsonResult
                    {
                        Success = false,
                        ModelState = ModelState
                    };

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update Project", "Projects Api"));

                    return JsonConvert.SerializeObject(result);
                }

                if (model.Id > 0)
                {
                    model.LoggedUserId = loggedUserId;
                    model.LoggedUserName = loggedUserName;
                    var projectId = _projectService.AddOrUpdate(model);

                    _userProjectService.DeleteProject(projectId);

                    var userIds = model.UserIds?.ToList();

                    if (userIds == null)
                    {
                        var usersList = new List<string> { userId };

                        userIds = usersList;
                    }
                    else
                    {
                        userIds.Add(userId);
                    }

                    if (teamLeadId != null)
                        userIds.Add(teamLeadId);

                    if (userIds != null && userIds.Any())
                    {
                        if (userIds[0] != null)
                        {
                            var selectedUserIds = userIds;

                            foreach (var selectedUserId in selectedUserIds)
                            {
                                var userProject = new UserProjectModel
                                {
                                    UserId = Convert.ToInt32(selectedUserId),
                                    ProjectId = projectId,
                                };

                                _userProjectService.AddOrUpdate(userProject);
                            }
                        }
                    }
                }

                var result1 = new BusinessViewJsonResult
                {
                    Success = true,
                };

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update Project", "Projects Api"));

                return JsonConvert.SerializeObject(result1);
            }

            var result2 = new BusinessViewJsonResult
            {
                Success = false,
                ModelState = ModelState
            };

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update Project", "Projects Api"));

            return JsonConvert.SerializeObject(result2);
        }

        [HttpPut]
        public string ArchiveOrUnArchiveProject(int archiveProjectId, bool isProjectArchive)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Archive Or UnArchive Project", "Projects Api"));

            try
            {
                var loggedUserId = User.Identity.GetUserId<int>();
                var loggedUserName = _userService.GetUserName(loggedUserId);

                if (archiveProjectId > 0)
                {
                    var model = new ProjectModel
                    {
                        LoggedUserId = loggedUserId,
                        LoggedUserName = loggedUserName,
                        Id = archiveProjectId,
                        IsArchived = isProjectArchive,
                        ArchivedDate = DateTime.Now
                    };

                    _projectService.ArchiveOrUnArchiveProject(model);
                }

                var result = new BusinessViewJsonResult
                {
                    Success = true,
                };

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Archive Or UnArchive Project", "Projects Api"));

                return JsonConvert.SerializeObject(result);
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Archive Or UnArchive Project", "Projects Api", ex.Message));

                throw;
            }
        }

        [HttpGet]
        [ActionName("GetUserProjects")]
        [Authorize]
        public List<UserProjectModel> GetUserProjects(int userId)
        {
            try
            {
                var projectsList = _userProjectService.GetProjectsBasedOnUser(userId);

                return projectsList.ToList();
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserProjects", "Projects Api", exception.Message));

                return null;
            }
        }

        [HttpGet]
        [ActionName("GetGoalsList")]
        [Authorize]
        public List<GoalViewModel> GetGoalsList(int userId, int projectId, bool isApproved)
        {
            try
            {
                var goalsList = _goalService.GetGoalsList(projectId, userId, isApproved);

                return goalsList.ToList();
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGoalsList", "Projects Api", exception.Message));

                return null;
            }
        }

        [HttpGet]
        [ActionName("GetGoalUserStories")]
        [Authorize]
        public ResultViewModel GetGoalUserStories(int userId, int goalId)
        {
            try
            {
                var userStoryDetails = _userStoryService.GetGoalUserStories(userId, goalId);

                return userStoryDetails;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGoalUserStories", "Projects Api", exception.Message));

                return null;
            }
        }

        [HttpGet]
        [ActionName("GetUserStoryAuditHistory")]
        [Authorize]
        public UserStoryAuditModel GetUserStoryAuditHistory(int userStoryId)
        {
            try
            {
                var userStoryDetails = _userStoryService.UserStoryAudit(userStoryId);

                return userStoryDetails;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGoalUserStories", "Projects Api", exception.Message));

                return null;
            }
        }      
    }
}