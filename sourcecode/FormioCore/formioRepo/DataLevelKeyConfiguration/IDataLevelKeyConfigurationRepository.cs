using formioModels.Data;
using formioModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioRepo.DataLevelKeyConfiguration
{
    public interface IDataLevelKeyConfigurationRepository
    {
        Guid? CreateLevelKeyConfiguration(DataLevelKeyConfigurationModel dataLevelKeyConfigurationModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GetDataLevelKeyConfigurationModel> SearchLevelKeyConfiguration(Guid? customApplicationId, Guid? levelId,bool? isArchived, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateLevelKeyConfiguration(DataLevelKeyConfigurationModel dataLevelKeyConfigurationModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
