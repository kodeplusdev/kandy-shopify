module ChatWidgetsHelper
  def collapsed_images
    [['Custom', 0], ['Operator - Group', 1], ['Operator - Female', 2], ['Operator - Male', 3], ['Chat Bubble', 4], ['Chat 1', 5],
     ['Contact Us Button 1', 6], ['Hello Female', 7], ['Support - Female', 8], ['Support 2 - Female', 9], ['Thumbs Up - Female', 10],
     ['Global', 11], ['Info', 12], ['Hello - Male', 13], ['Support - Male', 14], ['Support 2 - Male', 15], ['Thumbs Up - Male', 16],
     ['Snowman', 17], ['Baby Chicks', 18], ['Baby Otter', 19], ['Baby Panda', 20], ['Bunny', 21], ['Kitten', 22], ['Puppy', 23]]
  end

  def page_load_animations
    [['No Animation', 'none'], %w(bounce bounce), %w(flash flash), %w(pulse pulse), %w(rubberBand rubberBand), %w(shake shake),
     %w(swing swing), %w(tada tada), %w(wobble wobble), %w(bounceIn bounceIn), %w(bounceInDown bounceInDown),
     %w(bounceInLeft bounceInLeft), %w(bounceInRight bounceInRight), %w(bounceInUp bounceInUp), %w(bounceOut bounceOut),
     %w(bounceOutDown bounceOutDown), %w(bounceOutLeft bounceOutLeft), %w(bounceOutRight bounceOutRight), %w(bounceOutUp bounceOutUp),
     %w(fadeIn fadeIn), %w(fadeInDown fadeInDown), %w(fadeInDownBig fadeInDownBig), %w(fadeInLeft fadeInLeft), %w(fadeInLeftBig fadeInLeftBig),
     %w(fadeInRight fadeInRight), %w(fadeInRightBig fadeInRightBig), %w(fadeInUp fadeInUp), %w(fadeInUpBig fadeInUpBig), %w(fadeOut fadeOut),
     %w(fadeOutDown fadeOutDown), %w(fadeOutDownBig fadeOutDownBig), %w(fadeOutLeft fadeOutLeft), %w(fadeOutLeftBig fadeOutLeftBig),
     %w(fadeOutRight fadeOutRight), %w(fadeOutRightBig fadeOutRightBig), %w(fadeOutUp fadeOutUp), %w(fadeOutUpBig fadeOutUpBig),
     %w(flip flip), %w(flipInX flipInX), %w(flipInY flipInY), %w(flipOutX flipOutX), %w(flipOutY flipOutY), %w(lightSpeedIn lightSpeedIn),
     %w(lightSpeedOut lightSpeedOut), %w(rotateIn rotateIn), %w(rotateInDownLeft rotateInDownLeft), %w(rotateInDownRight rotateInDownRight),
     %w(rotateInUpLeft rotateInUpLeft), %w(rotateInUpRight rotateInUpRight), %w(rotateOut rotateOut), %w(rotateOutDownLeft rotateOutDownLeft),
     %w(rotateOutDownRight rotateOutDownRight), %w(rotateOutUpLeft rotateOutUpLeft), %w(rotateOutUpRight rotateOutUpRight),
     %w(slideInUp slideInUp), %w(slideInDown slideInDown), %w(slideInLeft slideInLeft), %w(slideInRight slideInRight),
     %w(slideOutUp slideOutUp), %w(slideOutDown slideOutDown), %w(slideOutLeft slideOutLeft), %w(slideOutRight slideOutRight),
     %w(hinge hinge), %w(rollIn rollIn), %w(rollOut rollOut)]
  end
end
