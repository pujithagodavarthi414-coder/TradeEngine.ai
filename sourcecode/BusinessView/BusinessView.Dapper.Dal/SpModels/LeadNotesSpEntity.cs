using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class LeadNotesSpEntity
    {
        public Guid LeadId { get; set; }
        public Guid NotesId { get; set; }
        public string Notes { get; set; }
        public string FileName { get; set; }
        public string FilePath { get; set; }
        public Guid FileId { get; set; }
    }
}
