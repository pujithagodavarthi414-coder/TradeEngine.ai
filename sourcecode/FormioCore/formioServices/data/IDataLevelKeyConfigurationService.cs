using formioModels.Data;
using formioModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioServices.data
{
    public interface IDataLevelKeyConfigurationService
    {
        Guid? CreateLevelKeyConfiguration(DataLevelKeyConfigurationModel dataLevelKeyConfigurationModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GetDataLevelKeyConfigurationModel> SearchLevelKeyConfiguration(Guid? customApplicationId, Guid? levelId,bool? isArchived, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}