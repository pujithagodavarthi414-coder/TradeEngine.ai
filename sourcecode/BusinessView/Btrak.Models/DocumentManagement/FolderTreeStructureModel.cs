using System;
using System.Collections.Generic;

public class FolderTreeStructureModel
{
    public Guid? FolderId { get; set; }
    public string FolderName { get; set; }
    public Guid? FileId { get; set; }
    public float? FolderSize { get; set; }
    public float? FileSize { get; set; }
    public string Extension { get; set; }
    public string FilePath { get; set; }
    public Guid? ParentFolderId { get; set; }
    public Guid? StoreId { get; set; }
    public Guid? FolderReferenceId { get; set; }
    public Guid? FolderReferenceTypeId { get; set; }
    public byte[] TimeStamp { get; set; }
    public List<FolderTreeStructureModel> Children { get; set; }

}
