﻿//------------------------------------------------------------------------------
//  <auto-generated>
//     This code was generated by a tool.
//     Runtime version: 4.0.30319.42000
//     Generator      : XSharp.CodeDomProvider 2.8.0.0
//     Timestamp      : 25/09/2021 12:02:47
//     
//     Changes to this file may cause incorrect behavior and may be lost if
//     the code is regenerated.
//  </auto-generated>
//------------------------------------------------------------------------------
BEGIN NAMESPACE XanthiClientTest_Raw

    PUBLIC PARTIAL CLASS MainWindow
        PRIVATE groupBox1 AS System.Windows.Forms.GroupBox
        PRIVATE label2 AS System.Windows.Forms.Label
        PRIVATE label1 AS System.Windows.Forms.Label
        PRIVATE portNumber AS System.Windows.Forms.NumericUpDown
        PRIVATE comboIPList AS System.Windows.Forms.ComboBox
        PRIVATE groupBox2 AS System.Windows.Forms.GroupBox
        PRIVATE tbPayLoad AS System.Windows.Forms.TextBox
        PRIVATE label5 AS System.Windows.Forms.Label
        PRIVATE label4 AS System.Windows.Forms.Label
        PRIVATE label3 AS System.Windows.Forms.Label
        PRIVATE buttonSend AS System.Windows.Forms.Button
        PRIVATE statusStrip1 AS System.Windows.Forms.StatusStrip
        PRIVATE statusLabel AS System.Windows.Forms.ToolStripStatusLabel
        PRIVATE tbPayloadReply AS System.Windows.Forms.TextBox
        PRIVATE tbCommandReply AS System.Windows.Forms.TextBox
        PRIVATE tbCodeReply AS System.Windows.Forms.TextBox
        PRIVATE groupBox3 AS System.Windows.Forms.GroupBox
        PRIVATE groupBox4 AS System.Windows.Forms.GroupBox
        PRIVATE groupBox5 AS System.Windows.Forms.GroupBox
        PRIVATE buttonMultiSend AS System.Windows.Forms.Button
        PRIVATE tbMulti AS System.Windows.Forms.TextBox
        PRIVATE checkTasks AS System.Windows.Forms.CheckBox
        PRIVATE tbSessionIDReply AS System.Windows.Forms.TextBox
        PRIVATE label6 AS System.Windows.Forms.Label
        PRIVATE tbSessionID AS System.Windows.Forms.TextBox
        PRIVATE comboCommand AS System.Windows.Forms.ComboBox
        PRIVATE comboCode AS System.Windows.Forms.ComboBox
        PRIVATE components := NULL AS System.ComponentModel.IContainer

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        PROTECTED METHOD Dispose(disposing AS LOGIC) AS VOID  STRICT

            IF (disposing .AND. (components != null))
                components:Dispose()
            ENDIF
            SUPER:Dispose(disposing)
   RETURN

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        PRIVATE METHOD InitializeComponent() AS VOID STRICT
            SELF:groupBox1 := System.Windows.Forms.GroupBox{}
            SELF:portNumber := System.Windows.Forms.NumericUpDown{}
            SELF:label2 := System.Windows.Forms.Label{}
            SELF:label1 := System.Windows.Forms.Label{}
            SELF:comboIPList := System.Windows.Forms.ComboBox{}
            SELF:buttonSend := System.Windows.Forms.Button{}
            SELF:groupBox2 := System.Windows.Forms.GroupBox{}
            SELF:groupBox5 := System.Windows.Forms.GroupBox{}
            SELF:checkTasks := System.Windows.Forms.CheckBox{}
            SELF:buttonMultiSend := System.Windows.Forms.Button{}
            SELF:tbMulti := System.Windows.Forms.TextBox{}
            SELF:groupBox4 := System.Windows.Forms.GroupBox{}
            SELF:tbSessionIDReply := System.Windows.Forms.TextBox{}
            SELF:tbCommandReply := System.Windows.Forms.TextBox{}
            SELF:tbCodeReply := System.Windows.Forms.TextBox{}
            SELF:tbPayloadReply := System.Windows.Forms.TextBox{}
            SELF:groupBox3 := System.Windows.Forms.GroupBox{}
            SELF:comboCode := System.Windows.Forms.ComboBox{}
            SELF:comboCommand := System.Windows.Forms.ComboBox{}
            SELF:label6 := System.Windows.Forms.Label{}
            SELF:tbSessionID := System.Windows.Forms.TextBox{}
            SELF:label3 := System.Windows.Forms.Label{}
            SELF:label4 := System.Windows.Forms.Label{}
            SELF:label5 := System.Windows.Forms.Label{}
            SELF:tbPayLoad := System.Windows.Forms.TextBox{}
            SELF:statusStrip1 := System.Windows.Forms.StatusStrip{}
            SELF:statusLabel := System.Windows.Forms.ToolStripStatusLabel{}
            SELF:groupBox1:SuspendLayout()
            ((System.ComponentModel.ISupportInitialize)(SELF:portNumber)):BeginInit()
            SELF:groupBox2:SuspendLayout()
            SELF:groupBox5:SuspendLayout()
            SELF:groupBox4:SuspendLayout()
            SELF:groupBox3:SuspendLayout()
            SELF:statusStrip1:SuspendLayout()
            SELF:SuspendLayout()
            // 
            // groupBox1
            // 
            SELF:groupBox1:Controls:Add(SELF:portNumber)
            SELF:groupBox1:Controls:Add(SELF:label2)
            SELF:groupBox1:Controls:Add(SELF:label1)
            SELF:groupBox1:Controls:Add(SELF:comboIPList)
            SELF:groupBox1:Location := System.Drawing.Point{12, 12}
            SELF:groupBox1:Name := "groupBox1"
            SELF:groupBox1:Size := System.Drawing.Size{770, 59}
            SELF:groupBox1:TabIndex := 0
            SELF:groupBox1:TabStop := false
            SELF:groupBox1:Text := "Server Info"
            // 
            // portNumber
            // 
            SELF:portNumber:Location := System.Drawing.Point{389, 22}
            SELF:portNumber:Maximum := DECIMAL{<INT>{ 65535, 0, 0, 0 }}
            SELF:portNumber:Name := "portNumber"
            SELF:portNumber:Size := System.Drawing.Size{71, 22}
            SELF:portNumber:TabIndex := 1
            // 
            // label2
            // 
            SELF:label2:AutoSize := true
            SELF:label2:Location := System.Drawing.Point{341, 24}
            SELF:label2:Name := "label2"
            SELF:label2:Size := System.Drawing.Size{42, 17}
            SELF:label2:TabIndex := 2
            SELF:label2:Text := "Port :"
            // 
            // label1
            // 
            SELF:label1:AutoSize := true
            SELF:label1:Location := System.Drawing.Point{13, 24}
            SELF:label1:Name := "label1"
            SELF:label1:Size := System.Drawing.Size{28, 17}
            SELF:label1:TabIndex := 1
            SELF:label1:Text := "IP :"
            // 
            // comboIPList
            // 
            SELF:comboIPList:DropDownStyle := System.Windows.Forms.ComboBoxStyle.DropDownList
            SELF:comboIPList:FormattingEnabled := true
            SELF:comboIPList:Location := System.Drawing.Point{67, 21}
            SELF:comboIPList:Name := "comboIPList"
            SELF:comboIPList:Size := System.Drawing.Size{235, 24}
            SELF:comboIPList:TabIndex := 0
            // 
            // buttonSend
            // 
            SELF:buttonSend:Location := System.Drawing.Point{319, 119}
            SELF:buttonSend:Name := "buttonSend"
            SELF:buttonSend:Size := System.Drawing.Size{75, 23}
            SELF:buttonSend:TabIndex := 1
            SELF:buttonSend:Text := "Send"
            SELF:buttonSend:UseVisualStyleBackColor := true
            SELF:buttonSend:Click += System.EventHandler{ SELF, @buttonSend_Click() }
            // 
            // groupBox2
            // 
            SELF:groupBox2:Controls:Add(SELF:groupBox5)
            SELF:groupBox2:Controls:Add(SELF:groupBox4)
            SELF:groupBox2:Controls:Add(SELF:groupBox3)
            SELF:groupBox2:Location := System.Drawing.Point{12, 77}
            SELF:groupBox2:Name := "groupBox2"
            SELF:groupBox2:Size := System.Drawing.Size{770, 200}
            SELF:groupBox2:TabIndex := 2
            SELF:groupBox2:TabStop := false
            SELF:groupBox2:Text := "Message"
            // 
            // groupBox5
            // 
            SELF:groupBox5:Controls:Add(SELF:checkTasks)
            SELF:groupBox5:Controls:Add(SELF:buttonMultiSend)
            SELF:groupBox5:Controls:Add(SELF:tbMulti)
            SELF:groupBox5:Location := System.Drawing.Point{644, 28}
            SELF:groupBox5:Name := "groupBox5"
            SELF:groupBox5:Size := System.Drawing.Size{120, 166}
            SELF:groupBox5:TabIndex := 16
            SELF:groupBox5:TabStop := false
            SELF:groupBox5:Text := "Multi Send"
            // 
            // checkTasks
            // 
            SELF:checkTasks:AutoSize := true
            SELF:checkTasks:Location := System.Drawing.Point{6, 95}
            SELF:checkTasks:Name := "checkTasks"
            SELF:checkTasks:Size := System.Drawing.Size{80, 21}
            SELF:checkTasks:TabIndex := 2
            SELF:checkTasks:Text := "as Task"
            SELF:checkTasks:UseVisualStyleBackColor := true
            // 
            // buttonMultiSend
            // 
            SELF:buttonMultiSend:Location := System.Drawing.Point{31, 60}
            SELF:buttonMultiSend:Name := "buttonMultiSend"
            SELF:buttonMultiSend:Size := System.Drawing.Size{75, 23}
            SELF:buttonMultiSend:TabIndex := 1
            SELF:buttonMultiSend:Text := "Send"
            SELF:buttonMultiSend:UseVisualStyleBackColor := true
            SELF:buttonMultiSend:Click += System.EventHandler{ SELF, @buttonMultiSend_Click() }
            // 
            // tbMulti
            // 
            SELF:tbMulti:Location := System.Drawing.Point{6, 32}
            SELF:tbMulti:Name := "tbMulti"
            SELF:tbMulti:Size := System.Drawing.Size{100, 22}
            SELF:tbMulti:TabIndex := 0
            // 
            // groupBox4
            // 
            SELF:groupBox4:Controls:Add(SELF:tbSessionIDReply)
            SELF:groupBox4:Controls:Add(SELF:tbCommandReply)
            SELF:groupBox4:Controls:Add(SELF:tbCodeReply)
            SELF:groupBox4:Controls:Add(SELF:tbPayloadReply)
            SELF:groupBox4:Location := System.Drawing.Point{422, 28}
            SELF:groupBox4:Name := "groupBox4"
            SELF:groupBox4:Size := System.Drawing.Size{216, 166}
            SELF:groupBox4:TabIndex := 15
            SELF:groupBox4:TabStop := false
            SELF:groupBox4:Text := "Reply"
            // 
            // tbSessionIDReply
            // 
            SELF:tbSessionIDReply:Location := System.Drawing.Point{6, 32}
            SELF:tbSessionIDReply:Name := "tbSessionIDReply"
            SELF:tbSessionIDReply:ReadOnly := true
            SELF:tbSessionIDReply:Size := System.Drawing.Size{200, 22}
            SELF:tbSessionIDReply:TabIndex := 0
            // 
            // tbCommandReply
            // 
            SELF:tbCommandReply:Location := System.Drawing.Point{6, 63}
            SELF:tbCommandReply:Name := "tbCommandReply"
            SELF:tbCommandReply:ReadOnly := true
            SELF:tbCommandReply:Size := System.Drawing.Size{200, 22}
            SELF:tbCommandReply:TabIndex := 1
            // 
            // tbCodeReply
            // 
            SELF:tbCodeReply:Location := System.Drawing.Point{6, 91}
            SELF:tbCodeReply:Name := "tbCodeReply"
            SELF:tbCodeReply:ReadOnly := true
            SELF:tbCodeReply:Size := System.Drawing.Size{200, 22}
            SELF:tbCodeReply:TabIndex := 2
            // 
            // tbPayloadReply
            // 
            SELF:tbPayloadReply:Location := System.Drawing.Point{6, 119}
            SELF:tbPayloadReply:Name := "tbPayloadReply"
            SELF:tbPayloadReply:ReadOnly := true
            SELF:tbPayloadReply:Size := System.Drawing.Size{200, 22}
            SELF:tbPayloadReply:TabIndex := 3
            // 
            // groupBox3
            // 
            SELF:groupBox3:Controls:Add(SELF:comboCode)
            SELF:groupBox3:Controls:Add(SELF:comboCommand)
            SELF:groupBox3:Controls:Add(SELF:label6)
            SELF:groupBox3:Controls:Add(SELF:tbSessionID)
            SELF:groupBox3:Controls:Add(SELF:label3)
            SELF:groupBox3:Controls:Add(SELF:buttonSend)
            SELF:groupBox3:Controls:Add(SELF:label4)
            SELF:groupBox3:Controls:Add(SELF:label5)
            SELF:groupBox3:Controls:Add(SELF:tbPayLoad)
            SELF:groupBox3:Location := System.Drawing.Point{16, 28}
            SELF:groupBox3:Name := "groupBox3"
            SELF:groupBox3:Size := System.Drawing.Size{400, 166}
            SELF:groupBox3:TabIndex := 14
            SELF:groupBox3:TabStop := false
            SELF:groupBox3:Text := "Send"
            // 
            // comboCode
            // 
            SELF:comboCode:FormattingEnabled := true
            SELF:comboCode:Location := System.Drawing.Point{99, 91}
            SELF:comboCode:Name := "comboCode"
            SELF:comboCode:Size := System.Drawing.Size{200, 24}
            SELF:comboCode:TabIndex := 4
            // 
            // comboCommand
            // 
            SELF:comboCommand:FormattingEnabled := true
            SELF:comboCommand:Location := System.Drawing.Point{99, 63}
            SELF:comboCommand:Name := "comboCommand"
            SELF:comboCommand:Size := System.Drawing.Size{200, 24}
            SELF:comboCommand:TabIndex := 4
            // 
            // label6
            // 
            SELF:label6:AutoSize := true
            SELF:label6:Location := System.Drawing.Point{16, 35}
            SELF:label6:Name := "label6"
            SELF:label6:Size := System.Drawing.Size{81, 17}
            SELF:label6:TabIndex := 11
            SELF:label6:Text := "Session Id :"
            // 
            // tbSessionID
            // 
            SELF:tbSessionID:Location := System.Drawing.Point{99, 32}
            SELF:tbSessionID:Name := "tbSessionID"
            SELF:tbSessionID:Size := System.Drawing.Size{200, 22}
            SELF:tbSessionID:TabIndex := 0
            // 
            // label3
            // 
            SELF:label3:AutoSize := true
            SELF:label3:Location := System.Drawing.Point{16, 94}
            SELF:label3:Name := "label3"
            SELF:label3:Size := System.Drawing.Size{49, 17}
            SELF:label3:TabIndex := 6
            SELF:label3:Text := "Code :"
            // 
            // label4
            // 
            SELF:label4:AutoSize := true
            SELF:label4:Location := System.Drawing.Point{16, 66}
            SELF:label4:Name := "label4"
            SELF:label4:Size := System.Drawing.Size{79, 17}
            SELF:label4:TabIndex := 7
            SELF:label4:Text := "Command :"
            // 
            // label5
            // 
            SELF:label5:AutoSize := true
            SELF:label5:Location := System.Drawing.Point{16, 122}
            SELF:label5:Name := "label5"
            SELF:label5:Size := System.Drawing.Size{67, 17}
            SELF:label5:TabIndex := 8
            SELF:label5:Text := "Payload :"
            // 
            // tbPayLoad
            // 
            SELF:tbPayLoad:Location := System.Drawing.Point{99, 119}
            SELF:tbPayLoad:Name := "tbPayLoad"
            SELF:tbPayLoad:Size := System.Drawing.Size{200, 22}
            SELF:tbPayLoad:TabIndex := 3
            // 
            // statusStrip1
            // 
            SELF:statusStrip1:ImageScalingSize := System.Drawing.Size{20, 20}
            SELF:statusStrip1:Items:AddRange(<System.Windows.Forms.ToolStripItem>{ SELF:statusLabel })
            SELF:statusStrip1:Location := System.Drawing.Point{0, 285}
            SELF:statusStrip1:Name := "statusStrip1"
            SELF:statusStrip1:Size := System.Drawing.Size{794, 26}
            SELF:statusStrip1:TabIndex := 3
            SELF:statusStrip1:Text := "statusStrip1"
            // 
            // statusLabel
            // 
            SELF:statusLabel:Name := "statusLabel"
            SELF:statusLabel:Size := System.Drawing.Size{151, 20}
            SELF:statusLabel:Text := "toolStripStatusLabel1"
            // 
            // MainWindow
            // 
            SELF:AutoScaleDimensions := System.Drawing.SizeF{8, 16}
            SELF:AutoScaleMode := System.Windows.Forms.AutoScaleMode.Font
            SELF:ClientSize := System.Drawing.Size{794, 311}
            SELF:Controls:Add(SELF:statusStrip1)
            SELF:Controls:Add(SELF:groupBox2)
            SELF:Controls:Add(SELF:groupBox1)
            SELF:MaximizeBox := false
            SELF:MinimizeBox := false
            SELF:Name := "MainWindow"
            SELF:Text := "Test Xanthi - Raw Communication"
            SELF:Load += System.EventHandler{ SELF, @MainWindow_Load() }
            SELF:groupBox1:ResumeLayout(false)
            SELF:groupBox1:PerformLayout()
            ((System.ComponentModel.ISupportInitialize)(SELF:portNumber)):EndInit()
            SELF:groupBox2:ResumeLayout(false)
            SELF:groupBox5:ResumeLayout(false)
            SELF:groupBox5:PerformLayout()
            SELF:groupBox4:ResumeLayout(false)
            SELF:groupBox4:PerformLayout()
            SELF:groupBox3:ResumeLayout(false)
            SELF:groupBox3:PerformLayout()
            SELF:statusStrip1:ResumeLayout(false)
            SELF:statusStrip1:PerformLayout()
            SELF:ResumeLayout(false)
            SELF:PerformLayout()

        #endregion
    END CLASS 
END NAMESPACE
