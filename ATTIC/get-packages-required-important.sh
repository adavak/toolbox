#!/bin/bash
#Description: lists packages that have priority required or important.
aptitude search -F'%p' ~prequired ~pimportant
