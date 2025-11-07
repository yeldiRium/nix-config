package cli

import (
	"flag"
	"fmt"
)

var (
	ErrEnumSetDuplicate = fmt.Errorf("enum flag set already has a value")
)

type EnumFlagMapping[T ~string] struct {
	Name    string
	Aliases []string
	Value   T
}

type EnumFlagSet[T ~string] []EnumFlagMapping[T]

func (e EnumFlagSet[T]) MakeFlags(output *T, setName string, usage string) {
	alreadySeen := ""

	for _, mapping := range e {
		for _, alias := range mapping.Aliases {
			usage := fmt.Sprintf("%s (part of set %s)", usage, setName)
			if alias != mapping.Name {
				usage = fmt.Sprintf("[alias for %s] %s", mapping.Name, usage)
			}

			flag.BoolFunc(alias, usage, func(string) error {
				if alreadySeen != "" {
					return fmt.Errorf("%w: %s", ErrEnumSetDuplicate, alreadySeen)
				}

				*output = mapping.Value
				alreadySeen = alias

				return nil
			})
		}
	}
}
