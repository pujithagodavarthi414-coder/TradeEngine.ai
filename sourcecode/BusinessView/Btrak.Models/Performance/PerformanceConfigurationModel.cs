using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.Performance
{
    public class PerformanceConfigurationModel : InputModelBase
    {
        public PerformanceConfigurationModel() : base(InputTypeGuidConstants.PerformanceConfigCommandId)
        {
        }
        public Guid? ConfigurationId { get; set; }
        public string ConfigurationName { get; set; }
        public string FormJson { get; set; }
        public string SelectedRoles { get; set; }
        public Guid? OfUserId { get; set; }
        public List<Guid> SelectedRoleIds { get; set; }
        public bool IsDraft { get; set; }
        public bool ConsiderRole { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" ConfigurationId = " + ConfigurationId);
            stringBuilder.Append(", Name = " + ConfigurationName);
            stringBuilder.Append(", SelectedRoles = " + SelectedRoles);
            stringBuilder.Append(", FormJson = " + FormJson);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
