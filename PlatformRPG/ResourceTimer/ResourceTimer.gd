extends Resource

var movements:Array

func timer(user):
    var start = OS.get_system_time_msecs()
    #var start = OS.get_ticks_msec()
    var action_array = ["action4", "action3"]
    #print('ResourceTimer/ResourceTimer.gd: ', m)

    yield(user, action_array[1])
    yield(user, action_array[1])

#    for i in action_array:
#        yield(user, action_array[i])

    if OS.get_system_time_msecs() - start > 1400:
        return
        #print('ResourceTimer/ResourceTimer.gd: ', movements)
    else:
        print('ResourceTimer/ResourceTimer.gd: ',movements)
        return


