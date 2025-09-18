using BTrak.Common;
using System;

namespace Btrak.Models.Lives
{
    public class ValidatorSearchInputModel : SearchCriteriaInputModelBase
    {
        public ValidatorSearchInputModel() : base(InputTypeGuidConstants.ContractModelInputCommandTypeGuid)
        {
        }

        public bool? IsPagingRequired { get; set; }
        public Guid? ValidatorId { get; set; }
        public Guid? DataSourceId { get; set; }
        public Guid? DataSetId { get; set; }
    }
}
