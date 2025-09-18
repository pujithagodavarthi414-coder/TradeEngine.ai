using Btrak.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.ProjectFeature
{
    public interface IProjectFeatureService
    {
        List<ProjectFeatureModel> GetAllFeatureResposiblePersons(Guid projectId,LoggedInContext loggedInContext);
        List<FeatureList> ProjectFeatures(Guid projectId);
        bool AddProjectFeature(Guid userId, Guid featureId, string feature, Guid projectId, LoggedInContext loggedInContext);
        ProjectFeatureModel GetProjectFeatureDetails(Guid id, Guid projectId, LoggedInContext loggedInContext);
        bool AddFeature(Guid userId, string feature, Guid projectId, LoggedInContext loggedInContext);
        bool EditFeature(Guid featureId, string feature, Guid projectId, LoggedInContext loggedInContext);
        bool DetleteFeatureDetails(Guid featureId, Guid projectId, LoggedInContext loggedInContext);
        List<FeatureList> AutoCompleteFeatures(string featureName);
    }
}
