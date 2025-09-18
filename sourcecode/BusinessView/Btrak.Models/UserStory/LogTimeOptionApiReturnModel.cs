using System;
using System.Text;

namespace Btrak.Models.UserStory
{
    public class LogTimeOptionApiReturnModel
    {
        public Guid? LogTimeOptionId { get; set; }
        public string LogTimeOption { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("LogTimeOptionId = " + LogTimeOptionId);
            stringBuilder.Append(", LogTimeOption = " + LogTimeOption);
            return stringBuilder.ToString();
        }
    }
}
