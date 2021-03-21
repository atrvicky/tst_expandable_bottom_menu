# tst_expandable_bottom_menu
<div class="image123">
    <div class="imgContainer">
        <p>
            		<b>Current situation derived from Unicorndial:</b>
            		<br> https://pub.dev/packages/unicorndial
            	</p>
          	<img src="images/Start.png" height="100">
    </div>
    <div class="imgContainer">
        <p>
              		<b>Desired result:</b>
              	</p>
          	<img src="images/Result.png" height="100">
    </div>
    
</div>



# Todos
- [x] 1. <b>Make the buttons align perfectly</b> (it seems they are a bit mis aligned)
    <div class="imgContainer">
        <img src="images/todo_1.png" height="100">
    </div>
- [x] 2. <b>Only one sub-branch can be opened at a time</b>. So, when we click the "clock" and then click the "person". 
         The "clock"-branch should close. 
  <div class="imgContainer">
          <img src="images/todo_22.png" height="100">
  </div>
- [x] 3. <b>All branches of the menu should collapse when we click on the background</b> (I made the background purple, just so it is easier to understand what I mean with background)
    <div class="imgContainer">
            <img src="images/todo_3.png" height="100">
    </div>
- [x] 4. <b>All branches of the menu should collapse when we press the bank/phone button </b>(when we press the 2nd branch button)
    <div class="imgContainer">
            <img src="images/todo_5.png" height="100">
    </div>
- [x] 5. <b>All branches of the menu should collapse when we press the big X</b> (the main floatingactionbutton)
    <div class="imgContainer">
          <img src="images/todo_6.png" height="100">
    </div>
- [ ] 6. <b>When we add more buttons the spacings should be equal.</b> Please set a variable so I can adjust the spacing in 1 place.
    <div class="imgContainer">
          <img src="images/spacing.png" height="300">
    </div>
- [ ] 7. <b>When we add more buttons they should automatically only allow for 1 branch to be open at a time</b> It needs to be scalable, 
        so I need to be able to add and remove buttons without having to change the code too much.
    <div class="imgContainer">
          <img src="images/scalability.png" height="300">
    </div>
- [ ] 8. <b>Implement a bool value that we can change (changing inside the code for now is fine, I will implement a user prefs setting in my app).
        <br> If true => the menu will only collapse to the horizontal branch (except when we hit the big X)
        <br> If false => the whole menu will collapse (like the current situation) </br> 
        div class="imgContainer">
              <img src="images/collapse.png" height="300">
        </div>

    