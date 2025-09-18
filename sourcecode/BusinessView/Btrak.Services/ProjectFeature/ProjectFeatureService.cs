using Btrak.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Btrak.Dapper.Dal.Models;
using Btrak.Dapper.Dal.Repositories;

namespace Btrak.Services.ProjectFeature
{
    public class ProjectFeatureService : IProjectFeatureService
    {
        private readonly ProjectFeatureResposiblePersonRepository _projectFeatureResposiblePerson;
        private readonly ProjectFeatureRepository _projectFeatureRepository;

        public ProjectFeatureService()
        {
            _projectFeatureResposiblePerson = new ProjectFeatureResposiblePersonRepository();
            _projectFeatureRepository = new ProjectFeatureRepository();
        }

        public List<ProjectFeatureModel> GetAllFeatureResposiblePersons(Guid projectId,LoggedInContext loggedInContext)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get All Feature Resposible Persons", "Project Feature Service"));

                List<ProjectFeatureModel> FeatureResposiblePersons = new List<ProjectFeatureModel>();

                var data = _projectFeatureResposiblePerson.GetAllFeatureResposiblePersons(projectId,loggedInContext.CompanyGuid);

                foreach (var value in data)
                {
                    ProjectFeatureModel FeatureResposiblePerson = new ProjectFeatureModel
                    {
                        Id = value.Id,
                        ProjectFeatureId = value.ProjectFeatureId,
                        ProjectFeatureName = value.ProjectFeatureName,
                        UserId = value.UserId,
                        UserName = value.UserName
                    };
                    FeatureResposiblePersons.Add(FeatureResposiblePerson);
                }

                return FeatureResposiblePersons.OrderBy(x => x.ProjectFeatureName).ToList();
            }
            catch (Exception exception)
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get All Feature Resposible Persons", "Project Feature Service", exception));
                throw;
            }
        }

        public List<FeatureList> ProjectFeatures(Guid projectId)
        {
            List<FeatureList> featuresList = new List<FeatureList>();

            var list = new List<FeatureList>
            {
                new FeatureList
                {
                    Id = Guid.Empty,
                    Name = "Select Feature"
                }
            };

            list.AddRange(_projectFeatureResposiblePerson.SelectAllFeatures(projectId).Select(x => new FeatureList
            {
                Id = x.Id,
                Name = x.ProjectFeatureName
            }).OrderBy(x => x.Name).ToList());

            return list;
        }

        public List<FeatureList> AutoCompleteFeatures(string featureName)
        {
            List<FeatureList> featuresList = new List<FeatureList>();

            var list = new List<FeatureList>();

            list.AddRange(_projectFeatureResposiblePerson.AllProjectFeatures(featureName).Select(x => new FeatureList
            {
                Id = x.ProjectFeatureId,
                Name = x.ProjectFeatureName
            }).OrderBy(x => x.Name).ToList());

            return list;
        }

        public ProjectFeatureModel GetProjectFeatureDetails(Guid id, Guid projectId, LoggedInContext loggedInContext)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Project Feature Details", "Project Feature Service"));

                ProjectFeatureModel projectFeature = new ProjectFeatureModel();

                var data = _projectFeatureResposiblePerson.GetAllFeatureResposiblePersons(projectId,loggedInContext.CompanyGuid).Where(x => x.ProjectFeatureId == id).FirstOrDefault();

                if (data == null)
                {
                    projectFeature = new ProjectFeatureModel
                    {
                        UserId = Guid.Empty,
                        ProjectFeatureId = id
                    };
                }
                else
                {
                    projectFeature = new ProjectFeatureModel
                    {
                        Id = data.Id,
                        UserId = data.UserId,
                        ProjectFeatureId = data.ProjectFeatureId,
                        ProjectFeatureName = data.ProjectFeatureName
                    };
                }
                return projectFeature;
            }
            catch (Exception exception)
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Project Feature Details", "Project Feature Service", exception));
                throw;
            }
        }


        public bool AddFeature(Guid userId, string feature, Guid projectId, LoggedInContext loggedInContext)
        {
            ProjectFeatureDbEntity projectFeature = new ProjectFeatureDbEntity();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add Feature", "Project Feature Service"));

                var data = _projectFeatureRepository.SelectAll().Where(x => string.Equals(x.ProjectFeatureName, feature, StringComparison.OrdinalIgnoreCase) && x.ProjectId == projectId && x.IsDelete != true).FirstOrDefault();

                if (data == null)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add Feature", "Project Feature Service"));

                    Guid featureId = Guid.NewGuid();

                    projectFeature.Id = featureId;
                    projectFeature.ProjectFeatureName = feature;
                    projectFeature.CreatedDateTime = DateTime.Now;
                    projectFeature.CreatedByUserId = loggedInContext.LoggedInUserId;
                    projectFeature.ProjectId = projectId;

                    bool result =  _projectFeatureRepository.Insert(projectFeature);

                    if (result == true && userId != Guid.Empty)
                    {
                        return AddProjectFeature(userId, featureId, null, projectId, loggedInContext);
                    }
                    return result;
                }

                return false;

            }
            catch (Exception exception)
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add Feature", "Project Feature Service", exception));
                throw;
            }
        }

        public bool EditFeature(Guid featureId, string feature, Guid projectId, LoggedInContext loggedInContext)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Edit Feature", "Project Feature Service"));

                ProjectFeatureDbEntity projectFeature = new ProjectFeatureDbEntity();

                var data = _projectFeatureRepository.SelectAll().Where(x => x.Id == featureId && x.ProjectId == projectId && x.IsDelete != true).FirstOrDefault();

                if (data != null)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Edit Feature", "Project Feature Service"));

                    projectFeature.Id = featureId;
                    projectFeature.ProjectFeatureName = feature;
                    projectFeature.CreatedDateTime = data.CreatedDateTime;
                    projectFeature.CreatedByUserId = data.CreatedByUserId;
                    projectFeature.UpdatedByUserId = loggedInContext.LoggedInUserId;
                    projectFeature.UpdatedDateTime = DateTime.Now;
                    projectFeature.ProjectId = data.ProjectId;

                    bool result = _projectFeatureRepository.Update(projectFeature);

                    return result;
                }

                return true;

            }
            catch (Exception exception)
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Edit Feature", "Project Feature Service", exception));
                throw;
            }

        }


        public bool AddProjectFeature(Guid userId, Guid featureId , string feature, Guid projectId, LoggedInContext loggedInContext)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add Project Feature", "Project Feature Service"));

                ProjectFeatureResposiblePersonDbEntity projectFeature = new ProjectFeatureResposiblePersonDbEntity();

                var data = _projectFeatureResposiblePerson.SelectAll().Where(x => x.ProjectFeatureId == featureId && x.IsDelete != true).FirstOrDefault();

                if (feature != null)
                {
                    var editValue = _projectFeatureRepository.SelectAll().Where(x => string.Equals(x.ProjectFeatureName, feature, StringComparison.OrdinalIgnoreCase) && x.ProjectId == projectId && x.IsDelete != true).FirstOrDefault();
                    if(editValue == null)
                        EditFeature(featureId, feature, projectId,loggedInContext);
                }

                if (data != null)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add Project Feature", "Project Feature Service"));

                    projectFeature.Id = data.Id;
                    projectFeature.ProjectFeatureId = featureId;
                    projectFeature.UserId = userId;
                    projectFeature.CreatedDateTime = data.CreatedDateTime;
                    projectFeature.CreatedByUserId = data.CreatedByUserId;
                    projectFeature.UpdatedDateTime = DateTime.Now;
                    projectFeature.UpdatedByUserId = loggedInContext.LoggedInUserId;

                   return _projectFeatureResposiblePerson.Update(projectFeature);

                }

                projectFeature.Id = Guid.NewGuid();
                projectFeature.ProjectFeatureId = featureId;
                projectFeature.UserId = userId;
                projectFeature.CreatedDateTime = DateTime.Now;
                projectFeature.CreatedByUserId = loggedInContext.LoggedInUserId;

                return _projectFeatureResposiblePerson.Insert(projectFeature);

            }
            catch (Exception exception)
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add Project Feature", "Project Feature Service", exception));
                throw;
            }

        }

        public bool DetleteFeatureDetails(Guid featureId, Guid projectId, LoggedInContext loggedInContext)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Detlete Feature Details", "Project Feature Service"));

                return _projectFeatureResposiblePerson.DeleteFeatureDetails(projectId,featureId);
            }
            catch (Exception exception)
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Detlete Feature Details", "Project Feature Service", exception));
                throw;
            }

        }
    }
}
