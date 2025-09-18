using System;
using System.Collections.Generic;
using System.Text;
using formioCommon.Constants;

namespace formioModels.Data
{
    public class DataSourceSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public DataSourceSearchCriteriaInputModel() : base(InputTypeGuidConstants.DataSourceSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? Id { get; set; }
        public Guid? Key { get; set; }
        public Guid? CompanyModuleId { get; set; }
        public List<Guid> FormIds { get; set; }
        public List<Guid> UserCompanyIds { get; set; }
        public List<ParamsJsonModel> ParamsJson { get; set; }
        public string FormIdsList { get; set; }
        public bool IsCompanyBased { get; set; }
        public List<string> DataSourceType { get; set; }
        public bool? IsIncludedAllForms { get; set; }

    }
}
