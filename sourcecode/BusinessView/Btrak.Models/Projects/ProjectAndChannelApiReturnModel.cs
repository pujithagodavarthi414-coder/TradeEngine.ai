using System;
using System.Text;

namespace Btrak.Models.Projects
{
    public class ProjectAndChannelApiReturnModel
    {
        public Guid? ProjectId { get; set; }
        public string ProjectName { get; set; }
        public Guid? ChannelId { get; set; }
        public string ChannelName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ProjectId = " + ProjectId);
            stringBuilder.Append(", ProjectName = " + ProjectName);
            stringBuilder.Append(", ChannelId = " + ChannelId);
            stringBuilder.Append(", ChannelName = " + ChannelName);
            return stringBuilder.ToString();
        }
    }
}
