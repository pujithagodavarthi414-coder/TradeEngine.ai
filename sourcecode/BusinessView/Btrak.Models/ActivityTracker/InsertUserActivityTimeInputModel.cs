using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.ActivityTracker
{
    public class InsertUserActivityTimeInputModel : InputModelBase
    {
        public InsertUserActivityTimeInputModel() : base(InputTypeGuidConstants.InsertUserActivityTimeInputCommandTypeGuid)
        {

        }
        //public string MacAddress { get; set; }
        public Guid Id { get; set; }
        public string ApplicationName { get; set; }
        public bool IsApp { get; set; }
        public bool IsBackground { get; set; }
        public string AbsoluteAppName { get; set; }
        public DateTime ApplicationStartTime { get; set; }
        public DateTime ApplicationEndTime { get; set; }
        public DateTime ActivityDate { get; set; }
        public DateTime IdleTime { get; set; }
        public DateTime SpentTime { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            //stringBuilder.Append(", MacAddress" + MacAddress);
            stringBuilder.Append("Id = " + Id);
            stringBuilder.Append(", ApplicationName = " + ApplicationName);
            stringBuilder.Append(", IsApp = " + IsApp);
            stringBuilder.Append(", IsBackground = " + IsBackground);
            stringBuilder.Append(", ApplicationStartTime" + ApplicationStartTime);
            stringBuilder.Append(", ApplicationEndTime" + ApplicationEndTime);
            stringBuilder.Append(", TimeSpentOnApplication = " + ActivityDate);
            stringBuilder.Append(", IdleTime" + IdleTime);
            stringBuilder.Append(", SpentTime" + SpentTime);
            return stringBuilder.ToString();
        }
    }
}
