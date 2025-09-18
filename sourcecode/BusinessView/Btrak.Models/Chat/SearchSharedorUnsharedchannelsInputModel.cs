using System;

namespace Btrak.Models.Chat
{
    public class SearchSharedorUnsharedchannelsInputModel
    {
        public Guid UserId { get; set; }
        public bool IsShared { get; set; }
    }
}