using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Templates
{
   public  class TemplatesSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public TemplatesSearchCriteriaInputModel() : base(InputTypeGuidConstants.GoalSearchCriteriaInputCommandTypeGuid)
        {
            
        }
        public Guid? ProjectId { get; set; }
        public Guid? TemplateId { get; set; }
        public string TemplateName { get; set; }
        public Guid? TemplateResponsiblePersonId { get; set; }
    }
}
