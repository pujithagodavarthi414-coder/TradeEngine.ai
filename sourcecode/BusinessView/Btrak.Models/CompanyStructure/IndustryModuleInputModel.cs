using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.CompanyStructure
{
    public class IndustryModuleInputModel : InputModelBase
    {
        public IndustryModuleInputModel() : base(InputTypeGuidConstants.IndustryModuleInputCommandTypeGuid)
        {
        }
        public Guid? IndustryModuleId { get; set; }
        public Guid? IndustryId { get; set; }
        public Guid? ModuleId { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", IndustryModuleId   = " + IndustryModuleId);
            stringBuilder.Append(", IndustryId  = " + IndustryId);
            stringBuilder.Append(", ModuleId  = " + ModuleId);
            stringBuilder.Append(", IsArchived  = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
