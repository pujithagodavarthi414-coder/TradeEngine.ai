using System;
using System.Text;

namespace Btrak.Models.Work
{
    public class WorkApiReturnModel
    {
        public Guid? WorkId
        {
            get;
            set;
        }

        public string WorkJson
        {
            get;
            set;
        }

        public DateTime? Date
        {
            get;
            set;
        }

        public Guid? UserId
        {
            get;
            set;
        }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("WorkId = " + WorkId);
            stringBuilder.Append(", WorkJson = " + WorkJson);
            stringBuilder.Append(", Date = " + Date);
            stringBuilder.Append(", UserId = " + UserId);
            return stringBuilder.ToString();
        }
    }
}
