using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.ActTracker
{
    public class MostProductiveUsersInputModel
    {
        public string ApplicationTypeName { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
               

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();

            stringBuilder.Append("ApplicationTypeName" + ApplicationTypeName);
            stringBuilder.Append("DateFrom" + DateFrom);
            stringBuilder.Append("DateTo" + DateTo);
            
            return stringBuilder.ToString();
        }
    }
}
