using System;
using System.Collections.Generic;

namespace Btrak.Models
{
    public class FileExchangeDetails
    {
        public Guid SenderId { get; set; }

        public Guid ReceiverId { get; set; }

        public Guid? ChannelId { get; set; }

        public string SenderName { get; set; }

        public string ChannelName { get; set; }

        public List<Files> Files { get; set; }

        public Guid MessageId { get; set; }

        public Guid? ParentMessageId { get; set; }

    }

    public class Files
    {
        public string FilePath { get; set; }

        public string FileName { get; set; }

        public byte[] FileBytes { get; set; }

        public string FileType { get; set; }

        public Guid? MessageId { get; set; }

        public int ChunkId { get; set; }

        public Guid FileId { get; set; }
    }
}
