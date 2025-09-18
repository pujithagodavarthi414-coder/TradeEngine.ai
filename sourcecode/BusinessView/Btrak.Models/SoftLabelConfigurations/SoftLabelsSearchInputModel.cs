using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.SoftLabelConfigurations
{
    public class SoftLabelsSearchInputModel : SearchCriteriaInputModelBase
    {
        public SoftLabelsSearchInputModel() : base(InputTypeGuidConstants.SearchSoftLabel)
        {
        }
        public Guid? SoftLabelConfigurationId { get; set; }
    }
}
