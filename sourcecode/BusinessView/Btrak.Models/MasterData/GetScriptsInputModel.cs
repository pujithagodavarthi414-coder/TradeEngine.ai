using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.MasterData
{
    public class GetScriptsInputModel : SearchCriteriaInputModelBase
    {
        public GetScriptsInputModel() : base(InputTypeGuidConstants.GetScripts)
        {
        }

        public Guid? ScriptId { get; set; }
        public string ScriptName { get; set; }
        public string Version { get; set; }
        public Nullable<bool> IsLatest { get; set; }
        public string ScriptUrl { get; set; }
        public string Description { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" ScriptId = " + ScriptId);
            stringBuilder.Append(", Name = " + ScriptName);
            stringBuilder.Append(", Version = " + Version);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", ScriptUrl = " + ScriptUrl);
            return stringBuilder.ToString();
        }
    }
}
