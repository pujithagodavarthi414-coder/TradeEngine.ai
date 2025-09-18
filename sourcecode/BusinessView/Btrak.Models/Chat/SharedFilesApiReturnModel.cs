using System;

namespace Btrak.Models.Chat
{
    public class SharedFilesApiReturnModel
    {
         public Guid? SenderUserId { get; set; }

         public string FilePath { get; set; }

         public DateTime MessageCreatedDateTime { get; set; }
    }
}
