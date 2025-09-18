using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.ActivityTracker
{
    public class InsertUserActivityInputModel : InputModelBase
    {
        public InsertUserActivityInputModel() : base(InputTypeGuidConstants.InsertUserActivityInputCommandTypeGuid)
        {

        }

        public List<string> MacAddress { get; set; }
        public string DeviceId { get; set; }
        public int KeyStrokes { get; set; }
        public int MouseMovements { get; set; }
        public string ActivityToken { get; set; }
        public DateTime ActivityTime { get; set; }
        public string IdsXML { get; set; }
        public string UserIdleRecordXml { get; set; }

        public List<InsertUserActivityTimeInputModel> UserActivityTime { get; set; }
        public InsertUserActivityTimeInputModel UserIdleActivityTime { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", MacAddress" + MacAddress);
            stringBuilder.Append(", UserActivityTime = " + UserActivityTime);
            stringBuilder.Append(", UserIdleActivityTime = " + UserIdleActivityTime);
            stringBuilder.Append(", KeyStrokes = " + KeyStrokes);
            stringBuilder.Append(", MouseMovements = " + MouseMovements);
            stringBuilder.Append(", ActivityToken = " + ActivityToken);
            stringBuilder.Append(", IdsXML = " + IdsXML);
            return stringBuilder.ToString();
        }

    }
}
