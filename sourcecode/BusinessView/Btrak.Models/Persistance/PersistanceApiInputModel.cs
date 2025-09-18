using System;
using System.Text;

namespace Btrak.Models.Persistance
{
    public class PersistanceApiInputModel
    {
        public Guid? ReferenceId { get; set; }
        public bool IsUserLevel { get; set; }
        public string PersistanceJson { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ReferenceId = " + ReferenceId);
            stringBuilder.Append(", IsUserLevel = " + IsUserLevel);
            stringBuilder.Append(", PersistanceJson = " + PersistanceJson);
            return stringBuilder.ToString();
        }
    }
}
