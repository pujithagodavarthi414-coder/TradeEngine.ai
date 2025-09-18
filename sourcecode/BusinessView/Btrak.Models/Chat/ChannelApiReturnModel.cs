using System;
using System.Text;

namespace Btrak.Models.Chat
{
    public class ChannelApiReturnModel
    {
        public Guid? Id { get; set; }
        public Guid CompanyId { get; set; }
        public string ChannelName { get; set; }
        public string ChannelImage { get; set; }
        public bool IsDeleted { get; set; }

        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }

        public int MessagesUnReadCount { get; set; }
        public bool IsMuted { get; set; }
        public bool IsStarred { get; set; }
        public string UserStoryName { get; set; }
        public bool IsReadOnly { get; set; }
        public int ChannelMemberCount { get; set; }
        public int PinnedMessageCount { get; set; }
        public int StarredMessageCount { get; set; }

        public Guid CreatedByUserId { get; set; }

        public string CreatedByUserName { get; set; }

        public Guid? CurrentOwnerShipId { get; set; }

        public string CurrentOwnerName { get; set; }

        public DateTime CreatedDateTime { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id = " + Id);
            stringBuilder.Append(", ChannelName = " + ChannelName);
            stringBuilder.Append(", ChannelImage = " + ChannelImage);
            stringBuilder.Append(", IsDeleted = " + IsDeleted);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", MessagesUnReadCount = " + MessagesUnReadCount);
            stringBuilder.Append(", IsMuted = " + IsMuted);
            stringBuilder.Append(", IsStarred = " + IsStarred);
            stringBuilder.Append(", UserStoryName = " + UserStoryName);
            stringBuilder.Append(", IsReadOnly = " + IsReadOnly);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", CreatedUserName = " + CreatedByUserName);
            stringBuilder.Append(", CurrentOwnerName = " + CurrentOwnerName);
            stringBuilder.Append(", CurrentOwnerShipId = " + CurrentOwnerShipId);
            stringBuilder.Append(", CreatedDate = " + CreatedDateTime);
            return stringBuilder.ToString();
        }
    }
}
