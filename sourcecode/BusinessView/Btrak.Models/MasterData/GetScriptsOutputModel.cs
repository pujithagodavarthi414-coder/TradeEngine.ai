using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class GetScriptsOutputModel
    {
        public Guid? ScriptId { get; set; }
        public string ScriptName { get; set; }
        public string Version { get; set; }
        public string Description { get; set; }
        public string ScriptUrl { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public string CreatedByUserName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" ScriptId = " + ScriptId);
            stringBuilder.Append(", ScriptName = " + ScriptName);
            stringBuilder.Append(", ScriptUrl = " + ScriptUrl);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", Version = " + Version);
            return stringBuilder.ToString();
        }
    }
}
