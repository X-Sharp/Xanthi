// CommandValue.prg
// Created by    : fabri
// Creation Date : 3/11/2022 12:42:39 PM
// Created for   : 
// WorkStation   : FABXPS


USING System
USING System.Collections.Generic
USING System.Text

BEGIN NAMESPACE XanthiTest

    /// <summary>
    /// RDD Command code : MUST be >= 100
    /// </summary>
    ENUM CommandValue
        MEMBER None := 100
        MEMBER DbEval
        MEMBER GoTop
        MEMBER GoBottom
        MEMBER GoTo
        MEMBER GoToId
        MEMBER Skip
        MEMBER SkipFilter
        MEMBER SkipRaw
        MEMBER SkipScope
        MEMBER Append
        MEMBER Delete
        MEMBER GetRec
        MEMBER Pack
        MEMBER PutRec
        MEMBER Recall
        MEMBER Zap
        MEMBER Close
        MEMBER Create
        MEMBER Open
        MEMBER ClearFilter
        MEMBER ClearScope
        MEMBER Continue
        MEMBER GetScope
        MEMBER SetFilter
        MEMBER SetScope
        MEMBER SetFieldExtent
        MEMBER AddField
        MEMBER CreateFields
        MEMBER FieldIndex
        MEMBER FieldInfo
        MEMBER FieldName
        MEMBER GetField
        MEMBER GetValue
        MEMBER GetValueFile
        MEMBER GetValueLength
        MEMBER Flush
        MEMBER GoCold
        MEMBER GoHot
        MEMBER PutValue
        MEMBER PutValueFile
        MEMBER Refresh
        MEMBER AppendLock
        MEMBER HeaderLock
        MEMBER Lock
        MEMBER UnLock
        MEMBER CloseMemFile
        MEMBER CreateMemFile
        MEMBER OpenMemFile
        MEMBER OrderCondition
        MEMBER OrderCreate
        MEMBER OrderDestroy
        MEMBER OrderInfo
        MEMBER OrderListAdd
        MEMBER OrderListDelete
        MEMBER OrderListFocus
        MEMBER OrderListRebuild
        MEMBER Seek
        MEMBER ChildEnd
        MEMBER ChildStart
        MEMBER ChildSync
        MEMBER ClearRel
        MEMBER ForceRel
        MEMBER RelArea
        MEMBER RelEval
        MEMBER RelText
        MEMBER SetRel
        MEMBER SyncChildren
        MEMBER Sort
        MEMBER Trans
        MEMBER TransRec
        MEMBER BlobInfo
        MEMBER Compile
        MEMBER EvalBlock
        MEMBER Info
        MEMBER RecInfo
    END ENUM


END NAMESPACE // XanthiClientTest_Raw