accessibles(fr::Full1DPointFrame, w::Point1D{Int}, ::_SuccessorRel)   = X(w)+1 > X(fr) ? Point1D{Int}[] : [Point1D{Int}(X(w)+1)]
accessibles(fr::Full1DPointFrame, w::Point1D{Int}, ::_PredecessorRel) = X(w)   < 2     ? Point1D{Int}[] : [Point1D{Int}(X(w)-1)]
accessibles(fr::Full1DPointFrame, w::Point1D{Int}, ::_GreaterRel)     = X(w)+1 > X(fr) ? Point1D{Int}[] : IterTools.imap(Point1D{Int}, ((X(w)+1):X(fr)))
accessibles(fr::Full1DPointFrame, w::Point1D{Int}, ::_LesserRel)      = X(w)   < 2     ? Point1D{Int}[] : IterTools.imap(Point1D{Int}, (1:(X(w)-1)))
accessibles(fr::Full1DPointFrame, w::Point1D{Int}, ::_MinRel)         = [Point1D{Int}(1)]
accessibles(fr::Full1DPointFrame, w::Point1D{Int}, ::_MaxRel)         = [Point1D{Int}(X(fr))]
